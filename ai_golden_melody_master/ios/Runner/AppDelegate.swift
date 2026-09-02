import Flutter
import UIKit
import UMCommon
// import WebKit


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//     // 获取Flutter引擎
//     let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//     // 注册Method Channel
//     let channel = FlutterMethodChannel(name: "com.by.ve.bridge", binaryMessenger: controller.binaryMessenger)
//
//     channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
//       guard call.method == "getUserAgent" else {
//         result(FlutterMethodNotImplemented)
//           return
//       }
//       // iOS获取User-Agent（使用WebView的默认值）
//       let webView = UIWebView() // 需导入WebKit
//       let userAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
//       result(userAgent)
//     }
    GeneratedPluginRegistrant.register(with: self)
    UMConfigure.initWithAppkey("685dfe6abc47b67d83982b67", channel:"AppStore")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
