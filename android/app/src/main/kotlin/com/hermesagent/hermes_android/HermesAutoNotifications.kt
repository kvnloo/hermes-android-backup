package com.hermesagent.hermes_android

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.Person
import androidx.core.app.RemoteInput
import org.json.JSONObject
import java.util.UUID

/** Notification/reply-only Android Auto integration. Tokens contain no credentials.
 * Action text and provenance use the existing Keystore-sealed native store.
 * No Activity, microphone, TTS, boot listener, sticky service or raw network client. */
internal object HermesAutoNotifications {
    const val REPLY = "com.hermesagent.hermes_android.AUTO_REPLY"
    const val READ = "com.hermesagent.hermes_android.AUTO_READ"
    const val OPEN = "com.hermesagent.hermes_android.AUTO_OPEN"
    private const val RECORDS = "auto_notifications"
    private const val CHANNEL = "hermes_auto_messaging"
    private fun now() = System.currentTimeMillis() / 1000
    private fun manager(c: Context) = c.getSystemService(NotificationManager::class.java)
    private fun policy(c: Context): Boolean {
        if (!manager(c).areNotificationsEnabled()) return false
        val raw = c.getSharedPreferences("FlutterSharedPreferences", 0).getString("flutter.hermes_notification_prefs", null)
        val prefs = if (raw == null) JSONObject() else runCatching { JSONObject(raw) }.getOrNull() ?: return false
        return prefs.optBoolean("enabled", true) && (prefs.optJSONObject("kinds")?.optBoolean("turnDone", true) != false)
    }
    private fun records(state: JSONObject) = state.optJSONObject(RECORDS) ?: JSONObject().also { state.put(RECORDS, it) }
    private fun valid(c: Context, row: JSONObject) = row.optLong("expires") > now() && policy(c) &&
        MobilePushBridge.autoAccountCurrent(c, row.optString("connectionId"), row.optJSONObject("metadata"))

    fun ticket(c: Context, args: Map<*, *>): Long? = synchronized(MobilePushBridge) {
        val metadata = args["metadata"] as? Map<*, *> ?: return null
        if (!MobilePushBridge.autoAccountCurrent(c, args["connectionId"] as? String ?: return null, JSONObject(metadata))) return null
        MobilePushStore.read(c).optLong("auto_epoch")
    }
    fun post(c: Context, args: Map<*, *>): Boolean = synchronized(MobilePushBridge) {
        val connection = args["connectionId"] as? String ?: return false
        val session = args["sessionId"] as? String ?: return false
        val binding = args["binding"] as? String ?: return false
        val metadata = args["metadata"] as? Map<*, *> ?: return false
        val id = (args["id"] as? Number)?.toInt() ?: return false
        if (id !in 0x10000000..0x1fffffff || !session.matches(Regex("[A-Za-z0-9_.:@-]{1,200}")) ||
            session == "__new__" || binding.isEmpty() || !policy(c) ||
            !MobilePushBridge.autoAccountCurrent(c, connection, JSONObject(metadata))) return false
        val token = UUID.randomUUID().toString()
        val state = MobilePushStore.read(c)
        if ((args["ticket"] as? Number)?.toLong() != state.optLong("auto_epoch")) return false
        val rows = records(state)
        rows.keys().asSequence().toList().forEach { key ->
            val old = rows.getJSONObject(key)
            if (old.optLong("expires") <= now() || old.optInt("id") == id) rows.remove(key)
        }
        // Bound sealed storage; expiry/single-use prevent delayed automatic replay.
        while (rows.length() >= 64) rows.remove(rows.keys().next())
        rows.put(token, JSONObject().put("connectionId", connection).put("sessionId", session)
            .put("binding", binding).put("metadata", JSONObject(metadata)).put("id", id)
            .put("expires", now() + 1800).put("status", "issued"))
        MobilePushStore.write(c, state) // write authority BEFORE exposing PendingIntents
        val mutable = if (Build.VERSION.SDK_INT >= 31) PendingIntent.FLAG_MUTABLE else 0
        fun action(kind: String, flags: Int) = PendingIntent.getBroadcast(c, 0,
            Intent(c, AutoMessageReceiver::class.java).setAction(kind).setData(Uri.parse("ares-auto://action/$token")),
            PendingIntent.FLAG_UPDATE_CURRENT or flags)
        val replyLabel = (args["replyLabel"] as? String) ?: "Reply"
        val readLabel = (args["readLabel"] as? String) ?: "Mark as read"
        val userLabel = (args["userLabel"] as? String) ?: "You"
        val remote = RemoteInput.Builder("reply").setLabel(replyLabel).build()
        val reply = action(REPLY, mutable)
        val read = action(READ, PendingIntent.FLAG_IMMUTABLE)
        val open = PendingIntent.getActivity(c, 0,
            Intent(c, MainActivity::class.java).setAction(OPEN).setData(Uri.parse("ares-auto://action/$token")),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val title = (args["title"] as? String).orEmpty().take(256)
        val body = (args["body"] as? String).orEmpty().take(16000)
        if (Build.VERSION.SDK_INT >= 26) manager(c).createNotificationChannel(NotificationChannel(
            CHANNEL, (args["channelLabel"] as? String) ?: "Ares conversations", NotificationManager.IMPORTANCE_DEFAULT))
        val style = NotificationCompat.MessagingStyle(Person.Builder().setName(userLabel).build())
            .setConversationTitle(title).setGroupConversation(false)
            .addMessage(body, System.currentTimeMillis(), Person.Builder().setName("Ares").setKey("assistant").build())
        val replyAction = NotificationCompat.Action.Builder(android.R.drawable.ic_btn_speak_now, replyLabel, reply)
            .addRemoteInput(remote).setAllowGeneratedReplies(true).setShowsUserInterface(false)
            .setSemanticAction(NotificationCompat.Action.SEMANTIC_ACTION_REPLY).build()
        val readAction = NotificationCompat.Action.Builder(android.R.drawable.ic_menu_close_clear_cancel, readLabel, read)
            .setShowsUserInterface(false).setSemanticAction(NotificationCompat.Action.SEMANTIC_ACTION_MARK_AS_READ).build()
        val car = NotificationCompat.CarExtender.UnreadConversation.Builder("Ares").addMessage(body)
            .setReadPendingIntent(read).setReplyAction(reply, remote).setLatestTimestamp(System.currentTimeMillis()).build()
        manager(c).notify(id, NotificationCompat.Builder(c, CHANNEL).setSmallIcon(R.drawable.ic_stat_mobile_push)
            .setContentTitle(title).setContentText(body).setStyle(style).setContentIntent(open)
            .setCategory(Notification.CATEGORY_MESSAGE).setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
            .setAutoCancel(true).addAction(replyAction).addAction(readAction)
            .extend(NotificationCompat.CarExtender().setUnreadConversation(car)).build())
        true
    }

    fun receive(c: Context, intent: Intent): Unit = synchronized(MobilePushBridge) {
        if (intent.action !in listOf(REPLY, READ, OPEN)) return
        val token = intent.data?.takeIf { it.scheme == "ares-auto" && it.host == "action" }?.lastPathSegment ?: return
        val state = MobilePushStore.read(c)
        val row = records(state).optJSONObject(token) ?: return
        if (row.optString("status") != "issued" || !valid(c, row)) return
        val text = if (intent.action == REPLY) RemoteInput.getResultsFromIntent(intent)?.getCharSequence("reply")?.toString() else null
        if (intent.action == REPLY && (text.isNullOrBlank() || text.length > 16000)) return
        row.put("status", "pending").put("kind", when (intent.action) { REPLY -> "reply"; READ -> "read"; else -> "open" })
        if (text != null) row.put("text", text)
        MobilePushStore.write(c, state)
        manager(c).cancel(row.getInt("id"))
        AutoMessagingPlugin.changed()
    }
    fun claim(c: Context): Map<String, Any?>? = synchronized(MobilePushBridge) {
        val state = MobilePushStore.read(c)
        val rows = records(state)
        for (token in rows.keys()) {
            val row = rows.getJSONObject(token)
            if (row.optString("status") != "pending" || !valid(c, row)) continue
            val result = mapOf("token" to token, "connectionId" to row.getString("connectionId"),
                "sessionId" to row.getString("sessionId"), "binding" to row.getString("binding"),
                "kind" to row.getString("kind"), "text" to row.optString("text"))
            // Lost acknowledgement is intentionally not retried: delivery is uncertain.
            row.put("status", "claimed").remove("text")
            MobilePushStore.write(c, state)
            return result
        }
        null
    }
    fun current(c: Context, token: String): Boolean = synchronized(MobilePushBridge) {
        val row = records(MobilePushStore.read(c)).optJSONObject(token) ?: return false
        row.optString("status") == "claimed" && valid(c, row)
    }
    fun cancel(c: Context, id: Int): Unit = synchronized(MobilePushBridge) {
        val state = MobilePushStore.read(c); val rows = records(state)
        // Invalidate outstanding post tickets before cleanup, even if this ID
        // has not reached notify() yet. Existing sibling records remain valid.
        state.put("auto_epoch", state.optLong("auto_epoch") + 1)
        rows.keys().asSequence().toList().forEach { key -> if (rows.getJSONObject(key).optInt("id") == id) rows.remove(key) }
        MobilePushStore.write(c, state)
        manager(c).cancel(id)
    }
    fun finish(c: Context, token: String) = synchronized(MobilePushBridge) {
        val state = MobilePushStore.read(c); records(state).remove(token); MobilePushStore.write(c, state)
    }
    fun invalidate(c: Context, ids: Set<String>? = null) = synchronized(MobilePushBridge) {
        val state = MobilePushStore.read(c); val rows = records(state)
        state.put("auto_epoch", state.optLong("auto_epoch") + 1)
        val cancelled = mutableListOf<Int>()
        rows.keys().asSequence().toList().forEach { key ->
            val row = rows.getJSONObject(key)
            if (ids == null || row.optString("connectionId") in ids) { cancelled.add(row.optInt("id")); rows.remove(key) }
        }
        MobilePushStore.write(c, state) // durable revocation before fallible display cleanup
        cancelled.forEach { manager(c).cancel(it) }
    }
}

/** Broadcast delivery never launches the phone UI or blindly starts a Flutter isolate.
 * A live app drains immediately; after process death, a sealed pending action waits
 * for ordinary foreground startup, subject to the same expiry/revocation checks. */
class AutoMessageReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) { runCatching { HermesAutoNotifications.receive(context, intent) } }
}
