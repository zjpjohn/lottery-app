import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/package/vip-package.dart';
import 'package:lottery_app/components/adaptor.dart';

class VipCard extends StatelessWidget {
  List<Color> background;

  Color btnColor;

  Color goColor;

  double width;

  double height;

  double delta;

  EdgeInsets padding;

  EdgeInsets margin;

  VipCard({
    this.background,
    this.btnColor = Colors.white,
    this.goColor = Colors.white,
    this.width,
    this.height,
    this.delta: 4,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, VipPackagesPage(), login: true);
      },
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: background),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: Adaptor.width(5)),
                    child: Icon(
                      IconData(0xe6b5, fontFamily: 'iconfont'),
                      size: Adaptor.sp(24),
                      color: btnColor,
                    ),
                  ),
                  Text(
                    '成为会员畅享专家推荐',
                    style: TextStyle(
                      fontSize: Adaptor.sp(16),
                      fontWeight: FontWeight.w400,
                      color: btnColor,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: height - delta,
              height: height - delta,
              decoration: BoxDecoration(
                color: btnColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular((height - delta) / 2),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xffFFEBE4),
                  ],
                ),
              ),
              child: Text(
                'GO',
                style: TextStyle(
                  fontSize: Adaptor.sp(17),
                  color: this.goColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
