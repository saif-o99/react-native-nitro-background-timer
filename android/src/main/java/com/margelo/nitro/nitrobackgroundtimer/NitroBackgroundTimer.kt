package com.margelo.nitro.nitrobackgroundtimer;

import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import java.util.Timer
import java.util.TimerTask
import com.facebook.proguard.annotations.DoNotStrip

@DoNotStrip
class NitroBackgroundTimer(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), HybridNitroBackgroundTimerSpec {

    private val handler = Handler(Looper.getMainLooper())
    private val powerManager = reactContext.getSystemService(ReactApplicationContext.POWER_SERVICE) as PowerManager
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
        reactContext.addLifecycleEventListener(lifecycleEventListener)
    }

    override fun getName(): String {
        return "RNBackgroundTimer"
    }

    @ReactMethod
    fun setTimeout(id: Int, duration: Int, callback: Callback) {
        if (!wakeLock.isHeld) {
            wakeLock.acquire()
        }

        val timer = Timer()
        timer.schedule(object : TimerTask() {
            override fun run() {
                handler.post {
                    callback.invoke(id)
                    timeoutTimers.remove(id)
                }
            }
        }, duration.toLong())
        timeoutTimers[id] = timer
    }

    @ReactMethod
    fun clearTimeout(id: Int) {
        timeoutTimers[id]?.cancel()
        timeoutTimers.remove(id)
        if (timeoutTimers.isEmpty() && intervalTimers.isEmpty() && wakeLock.isHeld) {
            wakeLock.release()
        }
    }

    @ReactMethod
    fun setInterval(id: Int, interval: Int, callback: Callback) {
        if (!wakeLock.isHeld) {
            wakeLock.acquire()
        }

        val timer = Timer()
        timer.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                handler.post {
                    callback.invoke(id)
                }
            }
        }, interval.toLong(), interval.toLong())
        intervalTimers[id] = timer
    }

    @ReactMethod
    fun clearInterval(id: Int) {
        intervalTimers[id]?.cancel()
        intervalTimers.remove(id)
        if (timeoutTimers.isEmpty() && intervalTimers.isEmpty() && wakeLock.isHeld) {
            wakeLock.release()
        }
    }
}
