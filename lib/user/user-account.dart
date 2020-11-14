import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/charge/recharge_records.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/help/about_account.dart';
import 'package:lottery_app/model/mine_account.dart';
import 'package:lottery_app/user/user_consume.dart';
import 'package:lottery_app/charge/recharge_page.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/user/user_coupon_exchange.dart';
import 'package:lottery_app/user/user_voucher_coupon.dart';
import 'package:lottery_app/user/user_voucher_record.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserAccountPage extends StatefulWidget {
  @override
  UserAccountPageState createState() => new UserAccountPageState();
}

class UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<UserAccountModel>(
        create: (_) => UserAccountModel.initialize(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                NavAppBar(
                  title: '我的账户',
                  fontColor: Color(0xFF59575A),
                  color: Colors.white,
                  left: Container(
                    height: Adaptor.width(32),
                    width: Adaptor.height(32),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      IconData(Constant.backIcon, fontFamily: 'iconfont'),
                      size: Adaptor.sp(16),
                      color: Color(0xFF59575A),
                    ),
                  ),
                  right: GestureDetector(
                    onTap: () {
                      AppNavigator.push(context, UserVoucherCouponPage());
                    },
                    child: Container(
                      height: Adaptor.height(24),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '卡券积分',
                        style: TextStyle(
                          color: Color(0xFF59575A),
                          fontSize: Adaptor.sp(13),
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<UserAccountModel>(builder: (BuildContext context,
                    UserAccountModel model, Widget child) {
                  return _buildContainer(model);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(UserAccountModel model) {
    if (model.loaded) {
      if (model.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                model.loadBalanceInfo();
              }),
            ],
          ),
        );
      }
      return _buildView(model);
    }
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Constant.loading(),
        ],
      ),
    );
  }

  Widget _buildView(UserAccountModel model) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _buildAcct(model),
          _buildListView(),
        ],
      ),
    );
  }

  Widget _buildAcct(UserAccountModel model) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Adaptor.width(20),
        top: Adaptor.width(32),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: Adaptor.height(144),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Adaptor.width(16)),
          padding: EdgeInsets.only(
            left: Adaptor.width(16),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/charge_bg.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(Adaptor.width(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                offset: Offset(4.0, 4.0),
                blurRadius: 16.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '金币',
                      style: TextStyle(
                        fontSize: Adaptor.sp(17),
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Adaptor.width(6)),
                      child: Text(
                        '${model.balance}',
                        style: TextStyle(
                          fontSize: Adaptor.sp(26),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '代金券',
                      style: TextStyle(
                        fontSize: Adaptor.sp(17),
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Adaptor.width(6)),
                      child: Text(
                        '${model.voucher}',
                        style: TextStyle(
                          fontSize: Adaptor.sp(26),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      AppNavigator.push(context, RechargePage()).then((value) {
                        if (value != null && value) {
                          model.loadBalanceInfo();
                        }
                      });
                    },
                    child: Container(
                      width: Adaptor.width(58),
                      height: Adaptor.height(38),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Adaptor.width(24)),
                          bottomLeft: Radius.circular(Adaptor.width(24)),
                        ),
                      ),
                      child: Text(
                        '充值',
                        style: TextStyle(
                          fontSize: Adaptor.sp(15),
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Container(
      margin: EdgeInsets.only(top: Adaptor.width(12)),
      child: Column(
        children: <Widget>[
          _getFunctionItem(
              title: '充值记录',
              icon: 0xe60d,
              color: Colors.redAccent,
              border: 1,
              margin: 0,
              callback: () {
                AppNavigator.push(context, RechargeRecords());
              }),
          _getFunctionItem(
              title: '消费记录',
              icon: 0xe6f1,
              color: Colors.redAccent,
              border: 1,
              margin: 0,
              callback: () {
                AppNavigator.push(context, UserConsumePage());
              }),
          _getFunctionItem(
              title: '兑换记录',
              icon: 0xe600,
              color: Colors.redAccent,
              border: 1,
              margin: 0,
              callback: () {
                AppNavigator.push(context, CouponExchangePage());
              }),
          _getFunctionItem(
              title: '代金券历史',
              icon: 0xe64f,
              color: Colors.redAccent,
              border: 1,
              margin: 0,
              callback: () {
                AppNavigator.push(context, VoucherRecordPage());
              }),
          _getFunctionItem(
              title: '关于账户',
              icon: 0xe648,
              color: Colors.redAccent,
              border: 0,
              margin: 0,
              callback: () {
                AppNavigator.push(context, AboutAccountPage());
              }),
        ],
      ),
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
          height: Adaptor.height(56),
          decoration: border == 1
              ? BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: Adaptor.height(0.25),
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
