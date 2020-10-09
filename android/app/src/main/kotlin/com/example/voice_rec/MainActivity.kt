package com.example.voice_rec

import android.content.ContentResolver
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "murilinhops/local_notifications_example"

    private fun resourceToUriString(context: Context, resId: Int): String {

            return ContentResolver.SCHEME_ANDROID_RESOURCE +
            "://" + context.getResources().getResourcePackageName(resId) + "/" +
            context.getResources().getResourceTypeName(resId) + "/" +
            context.getResources().getResourceEntryName(resId)
        }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
         MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler {
                call, result ->
                    if ("drawableToUri".equals(call.method)) {
                        var argumentos: String = call.arguments as String

                        var resourceId: Int = getResources()
                        .getIdentifier(argumentos, "drawable",
                        getPackageName())
                        result.success(resourceToUriString(getApplicationContext(), resourceId))
                } }
    }
}
