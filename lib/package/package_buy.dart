import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/pay_channel_widget.dart';
import 'package:lottery_app/components/vip_package_widget.dart';
import 'package:lottery_app/model/package_buy.dart';
import 'package:lottery_app/package/vip_help_notice.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class PackageBuyPage extends StatefulWidget {
  ///购买会员类型:0-新开会员，1-续约会员
  ///
  String packId;

  int type;

  PackageBuyPage({this.packId, this.type});

  @override
  PackageBuyPageState createState() => new PackageBuyPageState();
}

class PackageBuyPageState extends State<PackageBuyPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<PackageBuyModel>(
        create: (_) => PackageBuyModel.initialize(widget.packId),
        child: Scaffold(
          backgroundColor: Color(0xfff8f8f8),
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: widget.type == 0 ? '开通会员' : '会员续约',
                fontColor: Color(0xFF59575A),
                left: Container(
                  height: Adaptor.height(32),
                  width: Adaptor.width(32),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    IconData(Constant.backIcon, fontFamily: 'iconfont'),
                    size: Adaptor.sp(16),
                    color: Color(0xFF59575A),
                  ),
                ),
              ),
              Consumer<PackageBuyModel>(builder:
                  (BuildContext context, PackageBuyModel model, Widget child) {
                return _buildContainer(model);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(PackageBuyModel model) {
    if (model.loaded) {
      if (model.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                model.loadPackageInfo();
              }),
            ],
          ),
        );
      }
      return Expanded(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 0, bottom: Adaptor.height(56)),
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                  physics: EasyRefreshPhysics(topBouncing: false),
                  child: Column(
                    children: <Widget>[
                      _buildPackList(model),
                      _buildVoucher(),
                      _buildPayChannels(model),
                      _buildVipHelp(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildBuyAction(model),
            ),
          ],
        ),
      );
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

  Widget _buildBuyAction(PackageBuyModel model) {
    return Container(
      height: Adaptor.height(56),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        left: Adaptor.width(20),
        right: Adaptor.width(20),
      ),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(color: Color(0xffff1f1), width: Adaptor.width(0.2)),
        boxShadow: [
          BoxShadow(
            color: Color(0xfff1f1f1),
            offset: Offset(0.0, -5.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      right: Adaptor.width(2),
                    ),
                    child: Text(
                      '总计',
                      style: TextStyle(
                        color: Color(0xff4f4f4f),
                        fontSize: Adaptor.sp(16),
                        fontWeight: FontWeight.w400,
                        height: 0.999,
                      ),
                    ),
                  ),
                  Text(
                    '¥${model.vipPackage.discount}',
                    style: TextStyle(
                      color: Color(0xffFF421A),
                      fontSize: Adaptor.sp(17),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Text(
                '已减${(model.vipPackage.price - model.vipPackage.discount).floorToDouble()}元',
                style: TextStyle(
                  color: Color(0xffFF421A),
                  fontSize: Adaptor.sp(12),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              model.buyPackageAction(success: () {
                AppNavigator.goBack(context, true);
              });
            },
            child: Container(
              height: Adaptor.height(36),
              width: Adaptor.width(130),
              decoration: BoxDecoration(
                color: Color(0xFFE7B32A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    model.paying ? '正在支付' : '立即支付',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Adaptor.sp(18),
                    ),
                  ),
                  if (model.paying)
                    Padding(
                      padding: EdgeInsets.only(left: Adaptor.width(6)),
                      child: SpinKitRing(
                        color: Colors.white,
                        lineWidth: Adaptor.width(1.2),
                        size: Adaptor.width(18),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPayChannels(PackageBuyModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: Adaptor.width(12)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
              0,
              Adaptor.width(12),
              0,
              Adaptor.width(8),
            ),
            padding: EdgeInsets.only(left: Adaptor.width(20)),
            alignment: Alignment.centerLeft,
            child: Text(
              '支付方式',
              style: TextStyle(
                fontSize: Adaptor.sp(18),
                color: Color(0xFF59575A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]..addAll(
            model.channels.map(
              (v) => PayChannelView(
                data: v,
                selected:
                    model.channel != null && model.channel.channel == v.channel,
                onSelected: (value) {
                  model.channel = value;
                },
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildPackList(PackageBuyModel model) {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(top: Adaptor.width(12), bottom: Adaptor.width(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Adaptor.width(6),
              bottom: Adaptor.width(4),
              left: Adaptor.width(16),
            ),
            child: Text(
              '会员套餐',
              style: TextStyle(
                color: Color(0xFF59575A),
                fontSize: Adaptor.sp(18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: Adaptor.width(4),
              right: Adaptor.width(16),
              left: Adaptor.width(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List()
                ..addAll(
                  model.packages
                      .map(
                        (item) => VipPackageView(
                          height: Adaptor.height(58),
                          margin: EdgeInsets.only(
                            bottom: Adaptor.width(10),
                          ),
                          selected: model.vipPackage?.packId == item.packId,
                          onSelected: (value) {
                            model.vipPackage = value;
                          },
                          data: item,
                        ),
                      )
                      .toList(),
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucher() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: Adaptor.width(12)),
      padding: EdgeInsets.all(Adaptor.width(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '优惠券',
            style: TextStyle(
              color: Color(0xFF59575A),
              fontSize: Adaptor.sp(18),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '该档位暂无可用优惠券',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Adaptor.sp(13),
                  ),
                ),
                Icon(
                  IconData(0xe602, fontFamily: 'iconfont'),
                  size: Adaptor.sp(15),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipHelp() {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, VipHelpNotice());
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: Adaptor.width(12)),
        padding: EdgeInsets.symmetric(
          horizontal: Adaptor.width(16),
          vertical: Adaptor.width(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '会员业务说明帮助',
              style: TextStyle(
                color: Colors.black.withOpacity(0.65),
                fontSize: Adaptor.sp(16),
              ),
            ),
            Icon(
              IconData(0xe602, fontFamily: 'iconfont'),
              size: Adaptor.sp(16),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _loadPackageInfo() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
