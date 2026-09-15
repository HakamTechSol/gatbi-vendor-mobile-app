package com.gatbi.gatbivender

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Base64

class MainActivity : FlutterActivity() {

    private val channelName =
        "com.gatbi.gatbivender/file_download"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // ====================================================
                // Save Text File
                // ====================================================

                "saveTextFile" -> {

                    val content =
                        call.argument<String>("content")

                    val fileName =
                        call.argument<String>("fileName")

                    val mimeType =
                        call.argument<String>("mimeType")

                    if (content == null || fileName == null) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "File content or file name is missing.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {

                        val savedPath = saveTextFileToDownloads(
                            content = content,
                            fileName = fileName,
                            mimeType = mimeType
                                ?: "application/octet-stream"
                        )

                        result.success(savedPath)

                    } catch (e: Exception) {

                        result.error(
                            "FILE_SAVE_ERROR",
                            e.message
                                ?: "Unable to save file.",
                            null
                        )
                    }
                }

                // ====================================================
                // Save Bytes File
                // ====================================================

                "saveBytesFile" -> {

                    val base64Bytes =
                        call.argument<String>("bytes")

                    val fileName =
                        call.argument<String>("fileName")

                    val mimeType =
                        call.argument<String>("mimeType")

                    if (
                        base64Bytes == null ||
                        fileName == null
                    ) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "File bytes or file name is missing.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {

                        val bytes =
                            Base64.getDecoder().decode(base64Bytes)

                        if (bytes.isEmpty()) {
                            result.error(
                                "EMPTY_FILE",
                                "Cannot save an empty file.",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        val savedPath =
                            saveBytesFileToDownloads(
                                bytes = bytes,
                                fileName = fileName,
                                mimeType = mimeType
                                    ?: "application/octet-stream"
                            )

                        result.success(savedPath)

                    } catch (e: IllegalArgumentException) {

                        result.error(
                            "INVALID_BASE64",
                            "Invalid file data received.",
                            null
                        )

                    } catch (e: Exception) {

                        result.error(
                            "FILE_SAVE_ERROR",
                            e.message
                                ?: "Unable to save file.",
                            null
                        )
                    }
                }

                // ====================================================
                // Unknown Method
                // ====================================================

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // ================================================================
    // Save Text File To Downloads
    // ================================================================

    private fun saveTextFileToDownloads(
        content: String,
        fileName: String,
        mimeType: String
    ): String {

        return saveBytesFileToDownloads(
            bytes = content.toByteArray(Charsets.UTF_8),
            fileName = fileName,
            mimeType = mimeType
        )
    }

    // ================================================================
    // Save Binary File To Downloads
    // ================================================================

    private fun saveBytesFileToDownloads(
        bytes: ByteArray,
        fileName: String,
        mimeType: String
    ): String {

        val resolver = contentResolver

        val values = ContentValues().apply {

            put(
                MediaStore.Downloads.DISPLAY_NAME,
                fileName
            )

            put(
                MediaStore.Downloads.MIME_TYPE,
                mimeType
            )

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {

                put(
                    MediaStore.Downloads.RELATIVE_PATH,
                    Environment.DIRECTORY_DOWNLOADS
                )

                put(
                    MediaStore.Downloads.IS_PENDING,
                    1
                )
            }
        }

        val uri = resolver.insert(
            MediaStore.Downloads.EXTERNAL_CONTENT_URI,
            values
        ) ?: throw Exception(
            "Unable to create file in Downloads."
        )

        try {

            resolver.openOutputStream(uri)?.use { outputStream ->

                outputStream.write(bytes)

                outputStream.flush()

            } ?: throw Exception(
                "Unable to open file output stream."
            )

            // --------------------------------------------------------
            // Mark file as complete on Android 10+
            // --------------------------------------------------------

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {

                val updateValues =
                    ContentValues().apply {

                        put(
                            MediaStore.Downloads.IS_PENDING,
                            0
                        )
                    }

                resolver.update(
                    uri,
                    updateValues,
                    null,
                    null
                )
            }

            return uri.toString()

        } catch (e: Exception) {

            // --------------------------------------------------------
            // Cleanup partially-created file
            // --------------------------------------------------------

            resolver.delete(
                uri,
                null,
                null
            )

            throw e
        }
    }
}