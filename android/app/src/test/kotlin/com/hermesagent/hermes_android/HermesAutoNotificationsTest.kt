package com.hermesagent.hermes_android

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import androidx.core.app.RemoteInput
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import javax.crypto.KeyGenerator

/** Real notification/receiver/store; only Keystore acquisition is substituted. */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28])
class HermesAutoNotificationsTest {
    private lateinit var context: Context
    private lateinit var manager: NotificationManager
    @Before fun setup() {
        context = RuntimeEnvironment.getApplication()
        manager = context.getSystemService(NotificationManager::class.java)
        val key = KeyGenerator.getInstance("AES").apply { init(256) }.generateKey()
        MobilePushStore.keyProvider = { key }
        context.getSharedPreferences("mobile_push_sealed", 0).edit().clear().commit()
        context.getSharedPreferences("FlutterSharedPreferences", 0).edit().clear().commit()
        manager.cancelAll()
        saved("c", "profile-a")
    }
    private fun saved(id: String, profile: String) {
        val row = JSONObject().put("id", id).put("gateway_profile", profile).toString()
        context.getSharedPreferences("FlutterSharedPreferences", 0).edit().putString(
            EngineScopedPreferencesPlugin.SAVED_CONNECTIONS,
            EngineScopedPreferencesPlugin.JSON_LIST_PREFIX + org.json.JSONArray(listOf(row)).toString()).commit()
    }
    private fun post(id: Int = 0x10000001, session: String = "stored") =
        HermesAutoNotifications.post(context, mapOf("id" to id, "connectionId" to "c",
            "sessionId" to session, "binding" to "credential-hash", "title" to "Chat",
            "body" to "Private assistant answer", "ticket" to MobilePushStore.read(context).optLong("auto_epoch"), "metadata" to mapOf("id" to "c", "gateway_profile" to "profile-a")))
    private fun token(): String = MobilePushStore.read(context).getJSONObject("auto_notifications")
        .keys().asSequence().last()
    private fun receive(token: String, action: String = HermesAutoNotifications.REPLY) {
        val intent = Intent(context, AutoMessageReceiver::class.java).setAction(action)
            .setData(android.net.Uri.parse("ares-auto://action/$token"))
        if (action == HermesAutoNotifications.REPLY) RemoteInput.addResultsToIntent(
            arrayOf(RemoteInput.Builder("reply").build()), intent,
            android.os.Bundle().apply { putCharSequence("reply", "Dictated private text") })
        HermesAutoNotifications.receive(context, intent)
    }
    @Test fun messagingStyleHasReplyReadAndPrivateVisibility() {
        assertTrue(post())
        val n = manager.activeNotifications.single().notification
        assertEquals("android.app.Notification\$MessagingStyle", n.extras.getString("android.template"))
        assertEquals(android.app.Notification.VISIBILITY_PRIVATE, n.visibility)
        assertEquals(2, n.actions.size)
        assertTrue(n.actions[0].allowGeneratedReplies)
        assertFalse(n.actions[0].extras.getBoolean("android.support.action.showsUserInterface", true))
        assertEquals(android.app.Notification.Action.SEMANTIC_ACTION_MARK_AS_READ, n.actions[1].semanticAction)
    }
    @Test fun exactTokenClaimIsDurableSingleUseAndNeverPlaintext() {
        post(); val token = token(); receive(token)
        val claim = HermesAutoNotifications.claim(context)!!
        assertEquals("stored", claim["sessionId"])
        assertEquals("Dictated private text", claim["text"])
        assertNull(HermesAutoNotifications.claim(context))
        receive(token)
        assertNull(HermesAutoNotifications.claim(context))
        val raw = context.getSharedPreferences("mobile_push_sealed", 0).all.toString()
        assertFalse(raw.contains("Dictated private text"))
        assertFalse(raw.contains("Private assistant answer"))
    }
    @Test fun metadataMutationAndPreferenceRevocationInvalidateClaimedReply() {
        post(); val token = token(); receive(token); HermesAutoNotifications.claim(context)
        assertTrue(HermesAutoNotifications.current(context, token))
        MobilePushBridge.beforeMetadataWrite(context, null)
        assertFalse(HermesAutoNotifications.current(context, token))
        post(); val next = token(); receive(next); HermesAutoNotifications.claim(context)
        context.getSharedPreferences("FlutterSharedPreferences", 0).edit()
            .putString("flutter.hermes_notification_prefs", "{\"enabled\":false}").commit()
        assertFalse(HermesAutoNotifications.current(context, next))
    }
    @Test fun pendingReplyNeverLeaksIntoPushSnapshots() {
        post(); val token = token(); receive(token)
        val snapshot = MobilePushBridge.command(context, "snapshot", emptyMap<Any, Any>()) as Map<*, *>
        assertFalse(snapshot.containsKey("auto_notifications"))
        assertFalse(snapshot.toString().contains("Dictated private text"))
        assertNotNull(HermesAutoNotifications.claim(context))
    }
    @Test fun cancellationRevokesExactTokenWithoutRemovingSibling() {
        post(); val first = token(); receive(first); HermesAutoNotifications.claim(context)
        post(0x10000002, "sibling")
        HermesAutoNotifications.cancel(context, 0x10000001)
        assertFalse(HermesAutoNotifications.current(context, first))
        assertEquals(1, manager.activeNotifications.size)
    }
    @Test fun cancellationRejectsHeldPostTicketButKeepsSiblingAuthority() {
        post(0x10000002, "sibling")
        val sibling = token(); receive(sibling); HermesAutoNotifications.claim(context)
        val args = mapOf("connectionId" to "c", "metadata" to mapOf("id" to "c", "gateway_profile" to "profile-a"))
        val held = HermesAutoNotifications.ticket(context, args)!!
        HermesAutoNotifications.cancel(context, 0x10000001)
        assertFalse(HermesAutoNotifications.post(context, args + mapOf("id" to 0x10000001,
            "sessionId" to "stored", "binding" to "credential-hash", "ticket" to held)))
        assertTrue(HermesAutoNotifications.current(context, sibling))
    }
    @Test fun metadataComparisonDoesNotIgnoreCarNamedFields() {
        val row = JSONObject().put("id", "c").put("gateway_profile", "profile-a").put("auto_epoch", 1)
        context.getSharedPreferences("FlutterSharedPreferences", 0).edit().putString(
            EngineScopedPreferencesPlugin.SAVED_CONNECTIONS,
            EngineScopedPreferencesPlugin.JSON_LIST_PREFIX + org.json.JSONArray(listOf(row.toString())).toString()).commit()
        assertNull(HermesAutoNotifications.ticket(context, mapOf("connectionId" to "c",
            "metadata" to mapOf("id" to "c", "gateway_profile" to "profile-a", "auto_epoch" to 2))))
        assertNotNull(HermesAutoNotifications.ticket(context, mapOf("connectionId" to "c",
            "metadata" to mapOf("id" to "c", "gateway_profile" to "profile-a", "auto_epoch" to 1))))
    }
    @Test fun staleTicketCannotRecreateAuthorityAfterSameValueMutation() {
        val args = mapOf("connectionId" to "c", "metadata" to mapOf("id" to "c", "gateway_profile" to "profile-a"))
        val old = HermesAutoNotifications.ticket(context, args)!!
        MobilePushBridge.beforeMetadataWrite(context, null)
        assertFalse(HermesAutoNotifications.post(context, args + mapOf("id" to 0x10000001,
            "sessionId" to "stored", "binding" to "credential-hash", "ticket" to old)))
        assertTrue(post())
    }
    @Test fun expiredAndForeignProfileCannotClaimOrPost() {
        post(); val token = token()
        val state = MobilePushStore.read(context)
        state.getJSONObject("auto_notifications").getJSONObject(token).put("expires", 1)
        MobilePushStore.write(context, state)
        receive(token); assertNull(HermesAutoNotifications.claim(context))
        saved("c", "profile-b")
        assertFalse(post())
    }
    @Test fun nativeBeginRevokesBeforeCredentialWriteAndEndDoesNotRestore() {
        post(); val token = token(); receive(token); HermesAutoNotifications.claim(context)
        MobilePushBridge.command(context, "beginConnectionChange", mapOf("mutation" to "m", "connections" to listOf("c")))
        assertFalse(HermesAutoNotifications.current(context, token))
        MobilePushBridge.command(context, "endConnectionChange", mapOf("mutation" to "m"))
        assertFalse(HermesAutoNotifications.current(context, token))
        receive(token); assertNull(HermesAutoNotifications.claim(context))
    }
    @Test fun readIsScopedAndUnknownOrNewSessionsFailClosed() {
        assertFalse(post(session = "__new__"))
        post(); val first = token(); post(0x10000002, "sibling")
        receive(first, HermesAutoNotifications.READ)
        assertEquals(1, manager.activeNotifications.size)
        assertEquals("stored", HermesAutoNotifications.claim(context)!!["sessionId"])
        receive("invented")
        assertNull(HermesAutoNotifications.claim(context))
    }
}
