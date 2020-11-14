import 'package:flustars/flustars.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/login/login_page.dart';

///路由工具类
class AppNavigator {
  ///入栈方式压入页面
  static Future<T> push<T extends Object>(BuildContext context, Widget page,
      {bool login: false}) {
    ///页面跳转前权限判断
    ///
    if (login) {
      String user = SpUtil.getString('user');
      if (user == null || user.isEmpty) {
        return Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return new SlideTransition(
                textDirection: TextDirection.ltr,
                position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                    .animate(animation),
                child: LoginPage(),
              );
            },
          ),
        );
      }
    }
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return new SlideTransition(
            textDirection: TextDirection.ltr,
            position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                .animate(animation),
            child: page,
          );
        },
      ),
    );
  }

  ///替换页面
  static Future<T> replace<T extends Object>(
      BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return new SlideTransition(
            textDirection: TextDirection.ltr,
            position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                .animate(animation),
            child: page,
          );
        },
      ),
    );
  }

  ///指定页面加入到路由中，其它页面全部pop
  static Future<T> pushAndRemove<T extends Object>(
      BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            return new SlideTransition(
              textDirection: TextDirection.ltr,
              position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                  .animate(animation),
              child: page,
            );
          },
        ),
        (route) => route == null);
  }

  ///返回页面
  static void goBack<T extends Object>(BuildContext context, [T result]) {
    Navigator.pop(context, result);
  }

  ///带参返回
  static void goBackWithParam(BuildContext context, result) {
    Navigator.pop(context, result);
  }
}
