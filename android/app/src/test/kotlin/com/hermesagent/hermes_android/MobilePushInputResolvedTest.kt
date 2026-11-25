package com.hermesagent.hermes_android

import android.app.NotificationManager
import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import org.unifiedpush.android.connector.data.PushMessage
import javax.crypto.KeyGenerator

/** A question answered on another device: its `input_resolved` hint takes the
 * earlier `input` notification down and never posts a notification itself. */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28])
class MobilePushInputResolvedTest {
    private lateinit var context: Context
    private lateinit var manager: NotificationManager
    private val expiry get() = System.currentTimeMillis() / 1000 + 3600

    @Before fun setup() {
        context = RuntimeEnvironment.getApplication()
        val key = KeyGenerator.getInstance("AES").apply { init(256) }.generateKey()
        MobilePushStore.keyProvider = { key }
        manager = context.getSystemService(NotificationManager::class.java)
        context.getSharedPreferences("mobile_push_sealed", Context.MODE_PRIVATE).edit().clear().commit()
        manager.cancelAll()
        MobilePushBridge.detach()
        MobilePushStore.write(context, JSONObject().put("registration_fence", 1).put("enabled", true).put("active", true)
            .put("installation", "i").put("nonce", "private-nonce").put("revision", 2)
            .put("generation", 3).put("connection", "c").put("master", true)
            .put("sessions", JSONArray(listOf("durable-session")))
            .put("kinds", JSONArray(listOf("turn_done", "input", "input_resolved"))))
    }

    private fun hint(event: String, kind: String) = JSONObject()
        .put("schema", 1).put("event_id", event).put("kind", kind).put("generation", 3)
        .put("registration_nonce", "private-nonce").put("expires_at", expiry)

    private fun deliver(hint: JSONObject) {
        val service = Robolectric.buildService(MobilePushService::class.java).create().get()
        service.onMessage(PushMessage(hint.toString().toByteArray(), true), "i")
        service.onDestroy()
    }

    private fun issued(): List<String> {
        val issued = MobilePushStore.read(context).optJSONArray("issued") ?: JSONArray()
        return (0 until issued.length()).map { issued.getJSONObject(it).getString("event_id") }
    }

    @Test fun resolutionCancelsTheQuestionItAnswersAndPostsNothing() {
        deliver(hint("asked", "input"))
        deliver(hint("other", "input"))
        assertEquals(2, manager.activeNotifications.size)

        deliver(hint("answered", "input_resolved").put("resolves", "asked"))

        assertEquals(listOf("other".hashCode()), manager.activeNotifications.map { it.id })
        // A tap on the stale notification can no longer route anywhere.
        assertEquals(listOf("other"), issued())
        assertTrue(MobilePushStore.read(context).getJSONArray("seen").toString().contains("answered"))
    }

    @Test fun resolutionFromAnOlderServerStillPostsNothing() {
        deliver(hint("asked", "input"))
        deliver(hint("answered", "input_resolved"))
        assertEquals(listOf("asked".hashCode()), manager.activeNotifications.map { it.id })
    }
}
