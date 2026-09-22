package com.remembeer.app

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "quick_add_action"
    private var methodChannel: MethodChannel? = null

    /** Icon phase requested by Flutter, applied once the activity leaves the screen. */
    private var pendingAppIconPhase: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_ICON_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    APP_ICON_SET_METHOD -> {
                        val phase = call.argument<String>("phase")
                        if (phase == null || phase !in APP_ICON_PHASES) {
                            result.error("invalid_phase", "Unknown app icon phase: $phase", null)
                        } else {
                            pendingAppIconPhase = phase
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleQuickAddIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleQuickAddIntent(intent)
    }

    override fun onStop() {
        super.onStop()
        // Swapping the enabled launcher alias while the activity is visible makes
        // some launchers drop the icon or restart the task, so defer it until the
        // app goes to the background.
        applyPendingAppIcon()
    }

    private fun handleQuickAddIntent(intent: Intent) {
        if (intent.action == "QUICK_ADD_ACTION") {
            methodChannel?.invokeMethod("quickAddPressed", null)
        }
    }

    private fun applyPendingAppIcon() {
        val phase = pendingAppIconPhase ?: return
        pendingAppIconPhase = null

        val target = launcherAlias(phase)
        if (isAliasEnabled(target, phase)) {
            return
        }

        // Enable the new alias first so a launcher entry exists at all times.
        packageManager.setComponentEnabledSetting(
            target,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
        for (other in APP_ICON_PHASES) {
            if (other == phase) continue
            val alias = launcherAlias(other)
            if (isAliasEnabled(alias, other)) {
                packageManager.setComponentEnabledSetting(
                    alias,
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }
        }
    }

    private fun launcherAlias(phase: String): ComponentName =
        ComponentName(this, "$packageName.Bumblebeer${phase.uppercase()}")

    private fun isAliasEnabled(alias: ComponentName, phase: String): Boolean =
        when (packageManager.getComponentEnabledSetting(alias)) {
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED -> true
            PackageManager.COMPONENT_ENABLED_STATE_DEFAULT -> phase == DEFAULT_APP_ICON_PHASE
            else -> false
        }

    companion object {
        private const val APP_ICON_CHANNEL = "app_icon"
        private const val APP_ICON_SET_METHOD = "setIcon"
        /** Must match `AppIconPhase` in Dart and the `Bumblebeer*` aliases in the manifest. */
        private val APP_ICON_PHASES = listOf("a", "b", "c", "d", "e", "f", "g", "h")
        /** The alias enabled in the manifest. */
        private const val DEFAULT_APP_ICON_PHASE = "a"
    }
}
