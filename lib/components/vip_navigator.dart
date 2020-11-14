import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/package_buy.dart';
import 'package:lottery_app/package/vip-package.dart';

class VipNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, VipPackagesPage(), login: true);
      },
      child: Container(
        height: Adaptor.width(52),
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
          left: Adaptor.width(14),
          right: Adaptor.width(14),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vip_navigator.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: Adaptor.width(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'VIP会员限时抢',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adaptor.sp(17),
                ),
              ),
              Text(
                '畅享专家推荐',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adaptor.sp(12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
