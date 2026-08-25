package com.example.meu_carrinho

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private lateinit var importChannel: MethodChannel
    private val channelName = "meu_carrinho/import_intent"
    private var pendingImportPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        importChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        )
        importChannel.setMethodCallHandler { call, result ->
            if (call.method == "getInitialFile") {
                result.success(pendingImportPath)
                pendingImportPath = null
            } else {
                result.notImplemented()
            }
        }
        pendingImportPath = resolveIntentPath(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null || intent.action != Intent.ACTION_VIEW) return
        if (!::importChannel.isInitialized) return

        val data = intent.data ?: return
        val payload = resolveUriToFile(data) ?: data.toString()
        android.util.Log.d("MainActivity", "Intent payload: $payload")
        importChannel.invokeMethod("openFile", payload)
    }

    private fun resolveIntentPath(intent: Intent?): String? {
        if (intent?.action != Intent.ACTION_VIEW) return null
        val data = intent.data ?: return null
        val resolvedPath = resolveUriToFile(data)
        return resolvedPath ?: data.toString()
    }

    private fun resolveUriToFile(uri: Uri): String? {
        return when (uri.scheme) {
            "file" -> uri.path
            "content" -> {
                try {
                    val tempFile = File(
                        cacheDir,
                        "import_${System.currentTimeMillis()}.mlc",
                    )
                    contentResolver.openInputStream(uri)?.use { input ->
                        FileOutputStream(tempFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                    tempFile.absolutePath
                } catch (_: Exception) {
                    null
                }
            }
            else -> null
        }
    }
}
