package com.pmorales.wearos.tikitaka

import android.os.Bundle
import android.view.InputDevice
import android.view.MotionEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.pmorales.wearos.tikitaka/rotary"
    private var eventSink: EventChannel.EventSink? = null

    /** Makes the app assume the rounded canvas appearance on rounded screens. */
    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", "transparent")
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setStreamHandler(
                        object : EventChannel.StreamHandler {
                            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                                eventSink = events
                            }

                            override fun onCancel(arguments: Any?) {
                                eventSink = null
                            }
                        }
                )
    }

    override fun onGenericMotionEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_SCROLL &&
                        event.isFromSource(InputDevice.SOURCE_ROTARY_ENCODER)
        ) {
            val delta = -event.getAxisValue(MotionEvent.AXIS_SCROLL)
            val scrollPixels =
                    delta * android.view.ViewConfiguration.get(this).scaledVerticalScrollFactor
            eventSink?.success(scrollPixels)
            return true
        }
        return super.onGenericMotionEvent(event)
    }
}
