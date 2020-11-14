import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/concave_clipper.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/help/about_platform.dart';
import 'package:lottery_app/help/feedback_info.dart';
import 'package:lottery_app/login/login_page.dart';
import 'package:lottery_app/model/auth.dart';
import 'package:lottery_app/predict/register_master.dart';
import 'package:lottery_app/share/user_share.dart';
import 'package:lottery_app/user/user-account.dart';
import 'package:lottery_app/sign/sign-activity.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:lottery_app/predict/user-predict.dart';
import 'package:lottery_app/order/order_page.dart';
import 'package:lottery_app/help/help-center.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/user/user_detail.dart';
import 'package:lottery_app/subscribe/user-subscribes.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/user/user_voucher_coupon.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserHomePage extends StatefulWidget {
  @override
  UserHomePageState createState() => new UserHomePageState();
}

class UserHomePageState extends State<UserHomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: Color(0xFFF9F9F9),
        child: Column(
          children: <Widget>[
            NavAppBar(
              title: '个人中心',
              fontColor: Color(0xFF59575A),
              color: Color(0xFFF9F9F9),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                  physics: EasyRefreshPhysics(topBouncing: false),
                  child: Column(
                    children: <Widget>[
                      _getUserInfo(),
                      Stack(
                        children: <Widget>[
                          Container(
                            height: Adaptor.height(66),
                            margin: EdgeInsets.fromLTRB(
                              Adaptor.width(16),
                              0,
                              Adaptor.width(16),
                              0,
                            ),
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Adaptor.width(8)),
                                topRight: Radius.circular(Adaptor.width(8)),
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/vip_bg.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                AppNavigator.push(
                                  context,
                                  VipPackagesPage(),
                                  login: true,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: Adaptor.width(12),
                                    right: Adaptor.width(12),
                                    top: Adaptor.width(12)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: Adaptor.width(5)),
                                          child: Icon(
                                            IconData(0xe6b5,
                                                fontFamily: 'iconfont'),
                                            size: Adaptor.sp(18),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '开通立享多重特权',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Adaptor.sp(15),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: Adaptor.width(12),
                                        top: Adaptor.width(6),
                                        bottom: Adaptor.width(6),
                                      ),
                                      child: Text(
                                        '会员中心',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Adaptor.sp(14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: Adaptor.height(48),
                            child: ClipPath(
                              clipper: TopCurveClipper(
                                height: Adaptor.height(16),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 16.0,
                                      offset: Offset(0, -5.0),
                                    )
                                  ],
                                ),
                                child: Container(
                                  color: Colors.white,
                                  height: Adaptor.height(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Consumer<AuthModel>(
                        builder: (BuildContext context, AuthModel model,
                            Widget child) {
                          return Container(
                            transform: Matrix4.translationValues(
                                0, -Adaptor.height(5), 0),
                            child: Column(
                              children: <Widget>[
                                _getFunctionItem(
                                    title: '我的账户',
                                    icon: 0xe775,
                                    color: Color(0xFFFDE6D2),
                                    border: 1,
                                    margin: 0,
                                    callback: () {
                                      AppNavigator.push(
                                          context, UserAccountPage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '卡券 | 积分',
                                    icon: 0xe74e,
                                    color: Color(0xFFFDE6D2),
                                    border: 1,
                                    margin: 0,
                                    callback: () {
                                      AppNavigator.push(
                                          context, UserVoucherCouponPage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '我的收藏',
                                    icon: 0xe64e,
                                    color: Color(0xFFFDE6D2),
                                    border: 0,
                                    margin: 1,
                                    callback: () {
                                      AppNavigator.push(
                                          context, UserSubscribePage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '我的订单',
                                    icon: 0xe776,
                                    color: Color(0xFFEBD4EF),
                                    border: 1,
                                    margin: 0,
                                    callback: () {
                                      AppNavigator.push(
                                          context, UserOrdersPage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '我的邀请',
                                    icon: 0xe778,
                                    color: Color(0xFFEBD4EF),
                                    border: 1,
                                    margin: 0,
                                    callback: () {
                                      AppNavigator.push(
                                          context, UserSharePage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '我要预测',
                                    icon: 0xe779,
                                    color: Color(0xFFEBD4EF),
                                    border: 0,
                                    margin: 1,
                                    callback: () {
                                      AppNavigator.push(
                                        context,
                                        model.user != null &&
                                                model.user.isMaster == 1
                                            ? UserPredictPage()
                                            : RegisterMasterPage(),
                                        login: true,
                                      );
                                    }),
                                _getFunctionItem(
                                    title: '帮助中心',
                                    icon: 0xe6b6,
                                    color: Color(0xFFCCE6FF),
                                    border: 1,
                                    margin: 0,
                                    callback: () {
                                      AppNavigator.push(
                                          context, HelpCenterPage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '建议反馈',
                                    icon: 0xe652,
                                    color: Color(0xFFCCE6FF),
                                    border: 1,
                                    margin: 0,
                                    callback: () {
                                      AppNavigator.push(context, FeedbackPage(),
                                          login: true);
                                    }),
                                _getFunctionItem(
                                    title: '关于嚞彩',
                                    icon: 0xe604,
                                    color: Color(0xFFCCE6FF),
                                    border: 0,
                                    margin: 1,
                                    callback: () {
                                      AppNavigator.push(
                                        context,
                                        AboutPlatformPage(),
                                      );
                                    }),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogined(AuthModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            AppNavigator.push(
              context,
              UserDetailPage(),
              login: true,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${Tools.encodePhone(model.user.phone)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Adaptor.sp(30),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '上岸贵在坚持',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: Adaptor.sp(13),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/avatar.png',
                width: Adaptor.width(58),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            AppNavigator.push(context, SignActivityPage(), login: true);
          },
          child: Container(
            alignment: Alignment.center,
            width: Adaptor.width(70),
            height: Adaptor.height(30),
            margin: EdgeInsets.only(top: Adaptor.width(4)),
            padding: EdgeInsets.only(bottom: Adaptor.width(2)),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffFF4600).withOpacity(0.75),
                width: Adaptor.width(0.5),
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(Adaptor.height(4))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  IconData(0xe601, fontFamily: 'iconfont'),
                  size: Adaptor.sp(18),
                  color: Color(0xffFF4600).withOpacity(0.75),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Adaptor.width(6)),
                  child: Text(
                    '签到',
                    style: TextStyle(
                      color: Color(0xffFF4600).withOpacity(0.75),
                      fontSize: Adaptor.sp(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnLogin() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppNavigator.push(context, LoginPage());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '立即登录',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Adaptor.sp(30),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '嚞彩应用彩民的福地',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: Adaptor.sp(13),
                  ),
                )
              ],
            ),
          ),
          Image.asset(
            'assets/images/unlogin.png',
            width: Adaptor.width(58),
          ),
        ],
      ),
    );
  }

  Widget _getUserInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(16)),
      padding: EdgeInsets.fromLTRB(Adaptor.width(24), Adaptor.width(26),
          Adaptor.width(24), Adaptor.width(8)),
      alignment: Alignment.topCenter,
      child: Consumer<AuthModel>(
          builder: (BuildContext context, AuthModel model, Widget child) {
        return Container(
          height: Adaptor.height(100),
          alignment: Alignment.center,
          child: model.user != null ? _buildLogined(model) : _buildUnLogin(),
        );
      }),
    );
  }

  Widget _getFunctionItem(
      {String title,
      int icon,
      Color color,
      int border,
      double margin,
      Function callback}) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(Adaptor.width(16), 0, 0, 0),
      margin: margin == 1 ? EdgeInsets.only(bottom: Adaptor.width(12)) : null,
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Container(
          height: Adaptor.height(50),
          decoration: border == 1
              ? BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xfff1f1f1),
                      width: Adaptor.height(0.5),
                    ),
                  ),
                )
              : BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: Adaptor.width(12)),
                        child: Icon(
                          IconData(icon, fontFamily: 'iconfont'),
                          color: color,
                          size: Adaptor.sp(24),
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: Adaptor.sp(14), color: Color(0xFF5C5C5C)),
                      )
                    ],
                  ),
                ),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: Adaptor.width(16)),
                  child: Icon(
                    IconData(0xe602, fontFamily: 'iconfont'),
                    color: Color(0xFFbcbcbc),
                    size: Adaptor.sp(14),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
