package com.bmarket.baimarket

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Telephony
import android.os.Build
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.bai_market/sms"
    private var smsReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSmsCode") {
                registerSmsReceiver()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun registerSmsReceiver() {
        if (smsReceiver == null) {
            smsReceiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context, intent: Intent) {
                    if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
                        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
                        for (sms in messages) {
                            val messageBody = sms.messageBody
                            // Extract OTP code from message (assuming format: "Your code is: 1234")
                            val codeRegex = "\\b\\d{4}\\b".toRegex()
                            val matchResult = codeRegex.find(messageBody)
                            if (matchResult != null) {
                                val code = matchResult.value
                                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                                    .invokeMethod("onSmsReceived", code)
                                break
                            }
                        }
                    }
                }
            }

            val filter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
            registerReceiver(smsReceiver, filter)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        smsReceiver?.let {
            unregisterReceiver(it)
            smsReceiver = null
        }
    }
}
