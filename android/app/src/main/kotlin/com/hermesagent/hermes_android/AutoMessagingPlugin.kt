package com.hermesagent.hermes_android

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** No retained Activity/engine globals. Only live channels receive wake hints. */
internal class AutoMessagingPlugin : FlutterPlugin {
    private var channel: MethodChannel? = null
    private var attached = false
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        attached = true
        val c = binding.applicationContext
        // Remove only known legacy fork caches; never migrate plaintext auth or
        // queued auto-send text into new authority.
        c.getSharedPreferences("hermes_auto", 0).edit().clear().commit()
        c.getSharedPreferences("HermesCarAuthCache", 0).edit().clear().commit()
        channel = MethodChannel(binding.binaryMessenger, CHANNEL).also { ch ->
            synchronized(channels) { channels.add(ch) }
            ch.setMethodCallHandler { call, result ->
                try {
                    check(attached) { "Detached conversation owner" }
                    val args = call.arguments as? Map<*, *> ?: emptyMap<Any, Any>()
                    result.success(when (call.method) {
                        "ticket" -> HermesAutoNotifications.ticket(c, args)
                        "show" -> HermesAutoNotifications.post(c, args)
                        "claim" -> HermesAutoNotifications.claim(c)
                        "current" -> HermesAutoNotifications.current(c, args["token"] as String)
                        "cancel" -> { HermesAutoNotifications.cancel(c, (args["id"] as Number).toInt()); null }
                        "cancelAll" -> { HermesAutoNotifications.invalidate(c); null }
                        "finish" -> { HermesAutoNotifications.finish(c, args["token"] as String); null }
                        else -> { result.notImplemented(); return@setMethodCallHandler }
                    })
                } catch (_: Exception) { result.error("auto_unavailable", "Conversation action unavailable. Open Ares to review; do not resend an uncertain reply.", null) }
            }
        }
    }
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        attached = false
        channel?.let { synchronized(channels) { channels.remove(it) }; it.setMethodCallHandler(null) }
        channel = null
    }
    companion object {
        const val CHANNEL = "com.hermesagent.hermes_android/auto"
        private val channels = mutableSetOf<MethodChannel>()
        fun install(engine: FlutterEngine) { if (!engine.plugins.has(AutoMessagingPlugin::class.java)) engine.plugins.add(AutoMessagingPlugin()) }
        fun changed() {
            val targets = synchronized(channels) { channels.toList() }
            targets.forEach { it.invokeMethod("changed", null) }
        }
    }
}
