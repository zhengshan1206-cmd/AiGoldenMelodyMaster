import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/utils/by_init_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'binding/app_binding.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/build_config.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const_keys.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/environment.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/environment_config.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/channel.dart';
import 'navigator/app_pages.dart';
import 'navigator/router_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  FlutterBugly.postCatchedException(
    () async {
      BuildConfig.instantiate(
        envType: Environment.PRODUCTION,
        envConfig: EnvironmentConfig(),
      channelType: ChannelType.headlines,
      );

      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        ///强制竖屏
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // 设置状态栏样式
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF000000),
          // statusBarColor: Color(0xFF000000),
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,

          ///还有其他参数可自行查阅
          statusBarColor: Colors.transparent));

      await ScreenUtil.ensureScreenSize();

      await ByInitUtils.init();
      await ConstKeys().initUserAgentData();
      runApp(const KeyboardDismissOnTap(
        child: MyApp(),
      ));

      FlutterBugly.init(
        androidAppId: "4cd7859484",
        iOSAppId: "a1065cdf17",
      );
    },
    onException: (FlutterErrorDetails details) {
      byDebugPrint("检测到异常：\n${details.stack}");
    },
    debugUpload: true,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppBinding appBinding = AppBinding();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(
          idleIcon: const Icon(
            Icons.autorenew,
            size: 15,
            color: Colors.white,
          ),
          waterDropColor: Colors.white,
          refresh: defaultTargetPlatform == TargetPlatform.iOS
              ? const CupertinoActivityIndicator(
                  color: Colors.white,
                )
              : const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: ByColorUtil.color00CB64,
                ),
          complete: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.done,
                color: Colors.white,
              ),
              Container(
                width: 15.0,
              ),
              const Text(
                "刷新完成～",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
        footerBuilder: () => ClassicFooter(
          loadingText: "上滑加载更多~",
          canLoadingText: "上滑加载更多~",
          idleText: "上滑加载更多~",
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          canLoadingIcon: const Icon(Icons.autorenew, color: Colors.white),
          idleIcon: const Icon(Icons.arrow_upward, color: Colors.white),
          loadingIcon: SizedBox(
            width: 25.0,
            height: 25.0,
            child: defaultTargetPlatform == TargetPlatform.iOS
                ? const CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : const CircularProgressIndicator(strokeWidth: 2.0),
          ),
          noDataText: "没有更多了～",
        ), // 配置默认底部指示器
        headerTriggerDistance: 80.0, // 头部触发刷新的越界距离
        springDescription: const SpringDescription(
            stiffness: 170,
            damping: 16,
            mass: 1.9), // 自定义回弹动画,三个属性值意义请查询flutter api
        maxOverScrollExtent: 120, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        maxUnderScrollExtent: 0, // 底部最大可以拖动的范围
        enableScrollWhenRefreshCompleted:
            true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
        enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多

        child: GetMaterialApp(
          title: 'Ai金曲大师',
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('zh', 'CN'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Get.deviceLocale,
          routes: RouteUtils.routeList,
          initialRoute: RouterUtil.initialRoute(),
          initialBinding: appBinding,
          getPages: AppPages.routes,
          theme: ThemeData(
            dialogTheme: DialogTheme(
              // backgroundColor: Colors.white, // 对话框背景色
              // elevation: 24,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(12),
              // ),
              barrierColor: Colors.black.withOpacity(0.8), // 遮罩层颜色
            ),
            textSelectionTheme: TextSelectionThemeData(
              // 自定义剪切板按钮的背景颜色
              selectionHandleColor: ByColorUtil.color00CB64,
              // 自定义剪切板按钮的图标颜色
              // cursorColor: Colors.purple,
              selectionColor: ByColorUtil.color00CB64.withOpacity(0.3),
            ),
            useMaterial3: false,
            colorScheme: const ColorScheme.light(),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness:
                    GetPlatform.isAndroid ? Brightness.dark : Brightness.light,
              ), // 设置状态栏颜
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,

            // bottomSheetTheme: BottomSheetThemeData(
            //   backgroundColor: Colors.red
            // ),
            // bottomAppBarTheme: BottomAppBarTheme(
            //   color: Colors.red
            // )
          ),
          // home: const MainPage(),
          builder: EasyLoading.init(),
          color: ByColorUtil.color1E1E1E,
        ),
      ),
    );
  }
}
