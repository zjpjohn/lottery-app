import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/main/main_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  SplashScreenPageState createState() => new SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 780);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.white,
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      AppNavigator.pushAndRemove(context, MainPage());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
