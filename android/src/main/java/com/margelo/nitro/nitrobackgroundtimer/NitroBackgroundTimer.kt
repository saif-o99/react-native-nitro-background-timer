package com.margelo.nitro.nitrobackgroundtimer;

import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import java.util.Timer
import java.util.TimerTask
import com.facebook.proguard.annotations.DoNotStrip
import com.margelo.nitro.NitroModules
import android.util.Log

@DoNotStrip
class NitroBackgroundTimer : HybridNitroBackgroundTimerSpec() {
    private val context = NitroModules.applicationContext   ?: throw IllegalStateException("NitroModules.applicationContext is null")
    private val handler = Handler(Looper.getMainLooper())
    private val powerManager = context.getSystemService(ReactApplicationContext.POWER_SERVICE) as PowerManager
    private val wakeLock: PowerManager.WakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "RNBackgroundTimer")
    private val timeoutTimers = HashMap<Int, Timer>()
    private val intervalTimers = HashMap<Int, Timer>()

    private val lifecycleEventListener = object : LifecycleEventListener {
        override fun onHostResume() {}

        override fun onHostPause() {}

        override fun onHostDestroy() {
            if (wakeLock.isHeld) {
                wakeLock.release()
            }
        }
    }

    init {
        context.addLifecycleEventListener(lifecycleEventListener)
    }

    private fun releaseWakeLockIfNeeded() {
        if (timeoutTimers.isEmpty() && intervalTimers.isEmpty() && wakeLock.isHeld) {
            wakeLock.release()
        }
    }

    override fun setTimeout(id: Double, duration: Double, callback: (Double) -> Unit): Double {
        return try {
            val intId = id.toInt()

            if (!wakeLock.isHeld) {
                wakeLock.acquire()
            }

            val timer = Timer()
            timer.schedule(object : TimerTask() {
                override fun run() {
                    handler.post {
                        try {
                            callback(id)
                        } catch (e: Exception) {
                            Log.e("NitroBackgroundTimer", "Callback error in setTimeout($id): ${e.message}", e)
                        }
                        timeoutTimers.remove(intId)
                        releaseWakeLockIfNeeded()
                    }
                }
            }, duration.toLong())

            timeoutTimers[intId] = timer
            return id
        } catch (e: Exception) {
            Log.e("NitroBackgroundTimer", "Failed to setTimeout($id, $duration): ${e.message}", e)
            -1.0
        }
    }

    override fun clearTimeout(id: Double) {
        try {
            val intId = id.toInt()
            timeoutTimers[intId]?.cancel()
            timeoutTimers.remove(intId)
            releaseWakeLockIfNeeded()
        } catch (e: Exception) {
            Log.e("NitroBackgroundTimer", "Failed to clearTimeout($id): ${e.message}", e)
        }
    }

    override fun setInterval(id: Double, interval: Double, callback: (Double) -> Unit): Double {
        return try {
            val intId = id.toInt()

            if (!wakeLock.isHeld) {
                wakeLock.acquire()
            }

            val timer = Timer()
            timer.scheduleAtFixedRate(object : TimerTask() {
                override fun run() {
                    handler.post {
                        try {
                            callback(id)
                        } catch (e: Exception) {
                            Log.e("NitroBackgroundTimer", "Callback error in setInterval($id): ${e.message}", e)
                        }
                    }
                }
            }, interval.toLong(), interval.toLong())

            intervalTimers[intId] = timer
            return id
        } catch (e: Exception) {
            Log.e("NitroBackgroundTimer", "Failed to setInterval($id, $interval): ${e.message}", e)
            -1.0
        }
    }


    override fun clearInterval(id: Double) {
        try {
            val intId = id.toInt()
            intervalTimers[intId]?.cancel()
            intervalTimers.remove(intId)
            releaseWakeLockIfNeeded()
        } catch (e: Exception) {
            Log.e("NitroBackgroundTimer", "Failed to clearInterval($id): ${e.message}", e)
        }
    }
}
