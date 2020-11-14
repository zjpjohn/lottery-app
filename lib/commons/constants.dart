import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/avatar.dart';
import 'package:lottery_app/commons/config.dart';
import 'package:lottery_app/commons/tag_clipper.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/commons/wave.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/loading_widget.dart';

class Constant {
  static final RegExp zhcnRegex = new RegExp(r"(\w|[\u4E00-\u9FA5])");

  static const String keyGuide = 'keyGuide';

  ///导航栏高度
  ///
  static double barHeight = 44;

  ///返回icon
  ///
  static int backIcon = 0xe6ac;

  ///loading加载组件
  ///
  static Widget spin = SpinKitDualRing(
    color: Color(0x99c8c8c8),
    size: 26,
    lineWidth: 2.5,
  );

  static Widget verticleLine({
    double width = 1,
    double height = 10,
    Color color = Colors.black12,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color),
      ),
    );
  }

  static Widget loading() {
    return Loading(
      radiusL: Adaptor.width(4),
      radiusR: Adaptor.width(4),
      maxRadius: Adaptor.width(5),
      minRadius: Adaptor.width(2.5),
      gap: Adaptor.width(8),
    );
  }

  static const Map<int, String> number2Chinese = {
    1: '一',
    2: '二',
    3: '三',
    4: '四',
    5: '五',
    6: '六',
    7: '七',
    8: '八',
    9: '九'
  };

  ///颜色组
  ///
  static List<Color> reversColors = <Color>[
    const Color(0xFFF83600),
    const Color(0xc0FF512F),
  ];

  static List<Color> grayColors = <Color>[
    const Color(0xFFD0CFD7),
    const Color(0xFFE6E6E6),
  ];

  static List<Color> redColors = <Color>[
    Color(0xfffd7164),
    Color(0xfffd9e8a),
  ];

  ///颜色组
  ///
  static List<Color> colors = <Color>[
    const Color(0xFFFE8C00),
    const Color(0xFFF83600),
  ];

  ///0-9数字集合
  ///
  static List<int> balls = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  ///<editor-fold desc="双色球号码">
  static List<int> ssq = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
  ];

  ///</editor-fold>

  ///<editor-fold desc="七乐彩号码">
  static List<int> qlc = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
  ];

  ///</editor-fold>

  ///<editor-fold desc="大乐透红球号码">
  static List<int> dlt = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
  ];

  ///</editor-fold>

  //<editor-fold desc="双色球红球">
  static List<String> SSQ_RED = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33'
  ];

  //</editor-fold>

  //<editor-fold desc="双色球蓝球">
  static List<String> SSQ_BLUE = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16'
  ];

  //</editor-fold>

  //<editor-fold desc="大乐透红球">
  static List<String> DLT_RED = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35'
  ];

  //</editor-fold>

  //<editor-fold desc="大乐透篮球">
  static List<String> DLT_BLUE = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  //</editor-fold>

  //<editor-fold desc="七乐彩号码">
  static List<String> QLC_BALL = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ];

  //</editor-fold>

  ///横线
  static Widget line = const SizedBox(
    height: 0.6,
    width: double.infinity,
    child: const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xffeeeeee),
      ),
    ),
  );

  ///进度条
  ///
  static Widget progress = Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 1.2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.grey.withOpacity(0.1),
        ),
      ),
    ),
  );

  ///获取用户名首字母
  ///
  static String avatarName(String name) {
    String avatar = '';
    if (name != null) {
      String s = name.toUpperCase();
      for (int i = 0; i < s.length; i++) {
        String item = s.substring(i, i + 1);
        if (zhcnRegex.hasMatch(item)) {
          avatar = item;
          break;
        }
      }
    }
    return avatar;
  }

  ///标题栏
  ///
  static Widget header(
    String title,
    int icon, {
    double size: 16,
  }) {
    return Container(
      height: Adaptor.height(36),
      padding: EdgeInsets.fromLTRB(Adaptor.width(14), 0, Adaptor.width(14), 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: Adaptor.width(6)),
                    child: Icon(
                      IconData(icon, fontFamily: 'iconfont'),
                      size: Adaptor.sp(size),
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.sp(size),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  static Widget moreInfo(Function callback, EdgeInsets margin) {
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
          width: 90,
          height: 70,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2.0, 4.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                IconData(0xe6b1, fontFamily: 'iconfont'),
                size: 32,
                color: Colors.black12,
              ),
              Text(
                '更多专家',
                style: TextStyle(fontSize: 13, color: Colors.black38),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget wave(double width, double height) {
    return Container(
      width: width,
      height: height,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.all(0.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: WaveWidget(
          config: CustomConfig(
            colors: [
              const Color(0x02000000),
              const Color(0x05000000),
              const Color(0x08000000),
            ],
            heightPercentages: [0.20, 0.28, 0.36],
            blur: MaskFilter.blur(BlurStyle.normal, 0.0),
          ),
          backgroundColor: Colors.transparent,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }

  static Widget more(Function callback, EdgeInsets margin) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        margin: margin,
        width: 150,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 26,
              child: wave(150, 30),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '更多专家',
                    style: TextStyle(fontSize: 14, color: Color(0xffFF512F)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      IconData(0xe626, fontFamily: 'iconfont'),
                      size: 14,
                      color: Color(0xffFF512F),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget forecastCard(
    BuildContext context,
    String name,
    String rate,
    int series,
    Widget page,
    EdgeInsets margin,
  ) {
    String avatar = '';
    if (name != null) {
      String s = name.toUpperCase();
      for (int i = 0; i < s.length; i++) {
        String item = s.substring(i, i + 1);
        if (zhcnRegex.hasMatch(item)) {
          avatar = item;
          break;
        }
      }
    }
    return Container(
      margin: margin,
      height: 56,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(context, page, login: true);
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 26,
              child: wave(150, 30),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipPath(
                    clipper: TagClipper(),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(6, 1, 6, 0),
                      padding: EdgeInsets.fromLTRB(2, 3, 2, 7),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF5C01),
                            Color(0xBBFF5C01),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: series > 0
                            ? <Widget>[
                                Text(
                                  '连中',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '$series',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]
                            : <Widget>[
                                Text(
                                  '上期',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '未中',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                  Container(
                    height: 56,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Tools.limitText(name, 5),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          rate,
                          style: TextStyle(
                            color: Color(0xffFF512F),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 56,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(4, 4, 12, 4),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0x40FF4600),
                            const Color(0x15FF4600),
                          ],
                        ).createShader(Offset.zero & bounds.size);
                      },
                      child: Text(
                        avatar,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///用户卡片
  ///
  static Widget uCardVertical(
    BuildContext context,
    String name,
    String rate,
    int series,
    Widget page,
    EdgeInsets margin,
  ) {
    String avatar = '';
    if (name != null) {
      String s = name.toUpperCase();
      for (int i = 0; i < s.length; i++) {
        String item = s.substring(i, i + 1);
        if (zhcnRegex.hasMatch(item)) {
          avatar = item;
          break;
        }
      }
    }
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(context, page);
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Container(
                width: 90,
                height: 70,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2.0, 4.0),
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    series > 0
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '连续',
                                  style: TextStyle(
                                      fontSize: 11, color: Color(0xffFF512F)),
                                ),
                                Text(
                                  '$series',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffFF512F)),
                                ),
                                Text(
                                  '期中',
                                  style: TextStyle(
                                      fontSize: 11, color: Color(0xffFF512F)),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            '上期未命中',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffFF512F)),
                          ),
                    Container(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blueAccent, Colors.lightBlue],
                          ).createShader(Offset.zero & bounds.size);
                        },
                        child: Text(
                          '$rate',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0x30b721ff),
                        const Color(0x3021d4fd),
                      ],
                    ).createShader(Offset.zero & bounds.size);
                  },
                  child: Text(
                    avatar,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 30,
                child: wave(90, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget moreInfoH(BuildContext context, Function callback) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
      height: 80,
      width: MediaQuery.of(context).size.width * 0.45,
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2.0, 4.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                IconData(0xe6b1, fontFamily: 'iconfont'),
                size: 40,
                color: Colors.black12,
              ),
              Text(
                '更多专家',
                style: TextStyle(fontSize: 13, color: Colors.black38),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///用户卡片
  ///
  static Widget uCardHorizontal(
    BuildContext context,
    String name,
    String rate,
    int series,
    Widget page,
    EdgeInsets margin,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 80,
      margin: margin,
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(context, page);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2.0, 4.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Tools.limitText(name, 6),
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                    series > 0
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '连续',
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFFFF512F)),
                                ),
                                Text(
                                  '$series',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFF512F)),
                                ),
                                Text(
                                  '期中',
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFFFF512F)),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            '上期未命中',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFFFF512F)),
                          ),
                    Text(
                      '$rate',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Avatar(
                name,
                fontSize: 24,
                size: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  ///无内容处理
  ///
  static Widget noContent({String message, Function callback}) {
    return Center(
      child: InkWell(
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Icon(
                  IconData(0xe62b, fontFamily: 'iconfont'),
                  size: 96,
                  color: Colors.black12,
                ),
              ),
              Text(
                '$message',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///页面错误处理
  ///
  static Widget error(String message, Function callback) {
    return Center(
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/error.png',
                fit: BoxFit.contain,
                width: 100,
                height: 66,
              ),
              Text(
                '$message',
                style: TextStyle(fontSize: 13, color: Colors.black26),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///非拦截uri
  ///
  static Map<String, int> withoutAuth = {
    '/lottery/newest/list': 1,
    '/lottery/list': 1,
    '/lottery/table': 1,
    '/lottery/newest': 1,
    '/fc3d/glad': 1,
    '/pl3/glad': 1,
    '/ssq/glad': 1,
    '/dlt/glad': 1,
    '/qlc/glad': 1,
    '/fc3d/random/vip': 1,
    '/pl3/random/vip': 1,
    '/ssq/random/vip': 1,
    '/dlt/random/vip': 1,
    '/qlc/random/vip': 1,
    '/fc3d/top/masters': 1,
    '/pl3/top/masters': 1,
    '/ssq/top/masters': 1,
    '/dlt/top/masters': 1,
    '/qlc/top/masters': 1,
    '/news/list': 1,
    '/news/detail': 1,
    '/hmaster/fc3d': 1,
    '/hmaster/pl3': 1,
    '/hmaster/ssq': 1,
    '/hmaster/dlt': 1,
    '/hmaster/qlc': 1,
    '/user/login': 1,
    '/user/reset': 1,
    '/sms/send': 1,
    '/user/register': 1,
    '/global': 1,
    '/app': 1,
  };
}
