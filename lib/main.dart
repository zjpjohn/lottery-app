import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/main/splash_page.dart';
import 'package:lottery_app/model/app_info.dart';
import 'package:lottery_app/model/auth.dart';
import 'package:lottery_app/model/global_config.dart';
import 'package:lottery_app/model/open_install.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalConfigModel>(
          lazy: false,
          create: (_) => GlobalConfigModel.initialize(),
        ),
        ChangeNotifierProvider<AppInfoModel>(
          lazy: false,
          create: (_) => AppInfoModel.initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => OpenInstallModel.initialize(),
        ),
        ChangeNotifierProvider<AuthModel>(
          create: (_) => AuthModel.initialize(),
        ),
      ],
      child: AppHome(),
    ),
  );
  //状态栏一体化
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 36.0
    ..radius = 6.0
    ..lineWidth = 2
    ..userInteractions = false;
}

class AppHome extends StatefulWidget {
  @override
  AppHomeState createState() => new AppHomeState();
}

class AppHomeState extends State<AppHome> {
  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Color(0xFFF8F8F8),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        home: Scaffold(
          body: SplashScreenPage(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      precacheImage(AssetImage('assets/images/splash.png'), context);
      precacheImage(AssetImage('assets/images/logo.png'), context);
      precacheImage(AssetImage('assets/images/error.png'), context);
      precacheImage(AssetImage('assets/images/means-header.png'), context);
      precacheImage(AssetImage('assets/images/vip_card.jpg'), context);
      precacheImage(AssetImage('assets/images/fc3d.png'), context);
      precacheImage(AssetImage('assets/images/pl3.png'), context);
      precacheImage(AssetImage('assets/images/ssq.png'), context);
      precacheImage(AssetImage('assets/images/dlt.png'), context);
      precacheImage(AssetImage('assets/images/qlc.png'), context);
      precacheImage(AssetImage('assets/images/user.png'), context);
      precacheImage(AssetImage('assets/images/user_on.png'), context);
      precacheImage(AssetImage('assets/images/means.png'), context);
      precacheImage(AssetImage('assets/images/means_on.png'), context);
      precacheImage(AssetImage('assets/images/forecast.png'), context);
      precacheImage(AssetImage('assets/images/forecast_on.png'), context);
      precacheImage(AssetImage('assets/images/user.png'), context);
      precacheImage(AssetImage('assets/images/user_on.png'), context);
      precacheImage(AssetImage('assets/images/vip_bg.png'), context);
      precacheImage(AssetImage('assets/images/charge_bg.png'), context);
      precacheImage(AssetImage('assets/images/avatar.png'), context);
      precacheImage(AssetImage('assets/images/unlogin.png'), context);
      precacheImage(AssetImage('assets/images/situation.png'), context);
      precacheImage(AssetImage('assets/images/choice.png'), context);
      precacheImage(AssetImage('assets/images/hot.png'), context);
      precacheImage(AssetImage('assets/images/analysis.png'), context);
      precacheImage(AssetImage('assets/images/pk.png'), context);
      precacheImage(AssetImage('assets/images/checked.png'), context);
      precacheImage(AssetImage('assets/images/checked.png'), context);
      precacheImage(AssetImage('assets/images/checked_circle.png'), context);
      precacheImage(AssetImage('assets/images/ali_pay.png'), context);
      precacheImage(AssetImage('assets/images/wx_pay.png'), context);
      precacheImage(AssetImage('assets/images/voucher_ex.png'), context);
      precacheImage(AssetImage('assets/images/fc3d_vip_bg.png'), context);
      precacheImage(AssetImage('assets/images/pl3_vip_bg.png'), context);
      precacheImage(AssetImage('assets/images/ssq_vip_bg.png'), context);
      precacheImage(AssetImage('assets/images/dlt_vip_bg.png'), context);
      precacheImage(AssetImage('assets/images/qlc_vip_bg.png'), context);
      precacheImage(AssetImage('assets/images/share_bg.png'), context);
      precacheImage(AssetImage('assets/images/share_scan.png'), context);
      precacheImage(AssetImage('assets/images/share_register.png'), context);
      precacheImage(AssetImage('assets/images/default_avatar.png'), context);
      precacheImage(AssetImage('assets/images/empty.png'), context);
      precacheImage(AssetImage('assets/images/vip_navigator.png'), context);
      precacheImage(AssetImage('assets/images/qrcode_bg.png'), context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
