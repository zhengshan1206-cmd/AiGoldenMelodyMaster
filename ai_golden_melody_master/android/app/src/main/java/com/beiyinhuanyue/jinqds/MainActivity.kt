package com.beiyinhuanyue.jinqds

import android.content.Intent
import android.view.Window
import com.beiyinhuanyue.jinqds.GlobalConstant
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.ByPlugin
import io.flutter.plugins.GeneratedPluginRegistrant
import com.umeng.commonsdk.UMConfigure
import android.os.Bundle

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        UMConfigure.preInit(this, "685dff5179267e021095fc6c", "Dev")

    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
    }

    var videoEditResult: MethodChannel.Result? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GlobalConstant.FLUTTER_CHANNEL_NAME
        )
            .setMethodCallHandler(this)
    }



    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            //toAppInit
            GlobalConstant.APP_INIT -> {
                val appId = call.argument<String>("appid")
                val channel = call.argument<String>("channel")
                ByPlugin.iniBDConvert(applicationContext, activity, appId, channel)
                result.success(ByPlugin.baserResult(GlobalConstant.SUCCESS))
            }
            //头条SDK回传
            GlobalConstant.OCEANENGINE_EVENT -> {
                val params = call.argument<String>("params");
                ByPlugin.oceanengineEvent(params)
            }
            //toAPP设备信息
            GlobalConstant.APP_DEVICE_INFO -> {
                ByPlugin.getAndroidDeviceInfo(this) { oId, androidId ->
                    result.success(
                        ByPlugin.baserResult(
                            GlobalConstant.SUCCESS, mapOf(
                                "oId" to oId,
                                "androidId" to androidId
                            )
                        )
                    )
                }
            }

            //user-agent
            GlobalConstant.USER_AGENT -> {
                // Android获取User-Agent（使用系统WebView的默认值）
                val userAgent = System.getProperty("http.agent") // 系统默认User-Agent
                result.success(userAgent)
            }

            //视频编辑
            GlobalConstant.VIDEO_EDIT -> {}
            //视频去重
            GlobalConstant.COMPRESS_VIDEO -> {}
            //擦除
            GlobalConstant.VIDEO_CLEAN_WATERMARK -> {}
            //分离视频mp3和文案
            GlobalConstant.VIDEO_TO_AUDIO -> {}
            //录音
            GlobalConstant.RECORDING -> {}
            //获取音频文件的时长
            "multimediaFilesDuration" -> {}
            //获取视频帧图
            GlobalConstant.VIDEO_TO_IMG -> {}

            "myEdit" -> {}

            else -> {
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == RESULT_OK && null != data) {
            when (requestCode) {
                //视频去重
                GlobalConstant.COMPRESS_VIDEO_ACTIVITY_REQUEST_CODE -> {}
                //擦除
                GlobalConstant.VIDEO_CLEAN_WATERMARK_ACTIVITY_REQUEST_CODE -> {}
                GlobalConstant.RECORDING_ACTIVITY_REQUEST_CODE -> {}
            }
        } else {
            videoEditResult?.success(null)
        }
    }

}
