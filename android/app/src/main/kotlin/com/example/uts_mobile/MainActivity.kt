package com.example.uts_mobile

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    // Nama channel harus sama persis antara Kotlin dan Dart
    private val CHANNEL = "com.example.uts_mobile/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Method 1: Membaca persentase baterai HP
                    "getBatteryLevel" -> {
                        val batteryLevel = getBatteryLevel()
                        if (batteryLevel != -1) {
                            result.success(batteryLevel)
                        } else {
                            result.error("UNAVAILABLE", "Baterai tidak bisa dibaca", null)
                        }
                    }
                    // Method 2: Memunculkan Native Toast Android
                    "showToast" -> {
                        val message = call.argument<String>("message") ?: "Hello dari Native!"
                        Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
                        result.success("Toast ditampilkan")
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // Fungsi native untuk membaca level baterai
    private fun getBatteryLevel(): Int {
        val batteryIntent = applicationContext.registerReceiver(
            null,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )
        val level = batteryIntent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryIntent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        return if (level != -1 && scale != -1) {
            (level * 100 / scale.toFloat()).toInt()
        } else {
            -1
        }
    }
}
