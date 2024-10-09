package aayushsharma.me.sudoku

import android.app.Activity
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private lateinit var applinksMethodChannel: MethodChannel
    companion object {
        private const val APP_LINKS_CHANNEL_NAME = "SUDOKU_APPLINKS_METHODCHANNEL"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val action: String? = intent?.action
            if(action == "android.intent.action.VIEW") {
                Log.d("AppLinks", intent.data.toString())
                applinksMethodChannel.invokeMethod("onAppLinkOpened", intent?.data.toString())
            }
        } catch (e: Exception) {
            Log.d("MainActivity", e.toString())
        }
    }

    override fun onResume() {
        super.onResume()
        try {
            val action: String? = intent?.action
            if(action == "android.intent.action.VIEW") {
                Log.d("AppLinks", intent.data.toString())
                applinksMethodChannel.invokeMethod("onAppLinkOpened", intent?.data.toString())
            }
        } catch (e: Exception) {
            Log.d("MainActivity", e.toString())
        }
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        applinksMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_LINKS_CHANNEL_NAME)
    }
}
