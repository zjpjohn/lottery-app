import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/animate_number.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/model/voucher_coupon.dart';
import 'package:lottery_app/sign/sign-activity.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserVoucherCouponPage extends StatefulWidget {
  @override
  UserVoucherCouponPageState createState() => new UserVoucherCouponPageState();
}

class UserVoucherCouponPageState extends State<UserVoucherCouponPage> {
  ///[EasyRefreshController]refresh controller
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<VoucherCouponModel>(
        create: (_) => VoucherCouponModel.initialize(),
        child: Scaffold(
          body: Container(
            color: Color(0xFFF8F8F8),
            child: Column(
              children: <Widget>[
                NavAppBar(
                  title: '卡券 | 积分',
                  fontColor: Color(0xFF59575A),
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
                ),
                Consumer<VoucherCouponModel>(builder: (BuildContext context,
                    VoucherCouponModel model, Widget child) {
                  return _buildContainer(model);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(VoucherCouponModel model) {
    if (model.loaded) {
      if (model.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                setState(() {
                  model.loaded = false;
                });
                model.loadVoucher();
              }),
            ],
          ),
        );
      }
      return Expanded(
        child: EasyRefresh(
          controller: _controller,
          scrollController: ScrollController(),
          header: DeliveryHeader(),
          child: ListView.builder(
            itemCount: 3,
            padding: EdgeInsets.only(
              left: 0,
              right: 0,
              bottom: Adaptor.width(16),
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildContent(model, index);
            },
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 2000), () {
              model.loadVoucher();
            });
          },
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

  Widget _buildContent(VoucherCouponModel model, int index) {
    if (index == 0) {
      return Container(
        padding: EdgeInsets.only(
          left: Adaptor.width(40),
          right: Adaptor.width(40),
          top: Adaptor.width(24),
          bottom: Adaptor.width(24),
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.10),
              width: Adaptor.width(0.4),
            ),
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                  child: Text(
                    '代金券',
                    style: TextStyle(
                      color: Color(0xFF59575A).withOpacity(0.75),
                      fontSize: Adaptor.sp(14),
                    ),
                  ),
                ),
                Text(
                  '${model.voucher.voucher}',
                  style: TextStyle(
                    color: Color(0xFF59575A),
                    fontSize: Adaptor.sp(22),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                  child: Text(
                    '积分余额',
                    style: TextStyle(
                      color: Color(0xFF59575A).withOpacity(0.75),
                      fontSize: Adaptor.sp(14),
                    ),
                  ),
                ),
                Text(
                  '${model.voucher.coupon}',
                  style: TextStyle(
                    color: Color(0xFF59575A),
                    fontSize: Adaptor.sp(22),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                  child: Text(
                    '优惠券',
                    style: TextStyle(
                      color: Color(0xFF59575A).withOpacity(0.75),
                      fontSize: Adaptor.sp(14),
                    ),
                  ),
                ),
                Text(
                  '0',
                  style: TextStyle(
                    color: Color(0xFF59575A),
                    fontSize: Adaptor.sp(22),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
    if (index == 1) {
      return Container(
        margin: EdgeInsets.only(
          top: Adaptor.width(16),
          bottom: Adaptor.width(16),
        ),
        padding: EdgeInsets.only(
          top: Adaptor.width(20),
          bottom: Adaptor.width(20),
        ),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/voucher_ex.png',
              width: Adaptor.width(66),
              height: Adaptor.width(66),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Adaptor.width(2),
                bottom: Adaptor.width(4),
              ),
              child: Text(
                '可兑换积分',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: Adaptor.sp(15),
                ),
              ),
            ),
            AnimateNumber(
              number: model.voucher.coupon,
              start:
                  model.voucher.coupon - 6 > 0 ? model.voucher.coupon - 6 : 0,
              duration: 600,
              style: TextStyle(
                color: Color(0xFF59575A),
                fontSize: Adaptor.sp(28),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Adaptor.width(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (model.coupon.throttle > model.voucher.coupon) {
                        EasyLoading.showToast('积分余额不足');
                        return;
                      }
                      model.exchangeAction();
                    },
                    child: Container(
                      height: Adaptor.height(36),
                      width: Adaptor.width(100),
                      margin: EdgeInsets.only(right: Adaptor.width(16)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xff6D17E8).withOpacity(0.60),
                          Color(0xffCA13E7).withOpacity(0.60),
                        ]),
                        borderRadius: BorderRadius.circular(Adaptor.width(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            model.exchanging
                                ? '兑换中'
                                : (model.coupon.throttle < model.voucher.coupon
                                    ? '兑换积分'
                                    : '积分不足'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adaptor.sp(14),
                            ),
                          ),
                          if (model.exchanging)
                            Padding(
                              padding: EdgeInsets.only(left: Adaptor.width(6)),
                              child: SpinKitRing(
                                color: Colors.white,
                                lineWidth: Adaptor.width(1.2),
                                size: Adaptor.width(14),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigator.push(context, SignActivityPage());
                    },
                    child: Container(
                      height: Adaptor.height(36),
                      width: Adaptor.width(100),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xffCA13E7).withOpacity(0.5),
                          width: Adaptor.width(0.8),
                        ),
                        borderRadius: BorderRadius.circular(Adaptor.width(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: Adaptor.width(2)),
                            child: Text(
                              '签到',
                              style: TextStyle(
                                color: Color(0xffCA13E7).withOpacity(0.5),
                                fontSize: Adaptor.sp(14),
                              ),
                            ),
                          ),
                          Icon(
                            IconData(0xe60f, fontFamily: 'iconfont'),
                            size: Adaptor.sp(18),
                            color: Color(0xffCA13E7).withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Adaptor.width(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: Adaptor.width(4)),
                    child: Icon(
                      IconData(0xe68b, fontFamily: 'iconfont'),
                      size: Adaptor.sp(11),
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '账户积分余额大于${model.coupon.throttle}，且按照${model.coupon.exchange}:1兑换',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: Adaptor.sp(12),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (index == 2) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: Adaptor.width(8)),
        child: Column(
          children: <Widget>[]
            ..add(
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: Adaptor.width(16.0)),
                child: Text(
                  "兑换记录",
                  style: TextStyle(
                    fontSize: Adaptor.sp(17),
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
            ..addAll(
              _exchangeRecords(model),
            ),
        ),
      );
    }
  }

  List<Widget> _exchangeRecords(VoucherCouponModel model) {
    if (model.records.length > 0) {
      return List()
        ..addAll(
          model.records
              .map((log) => Container(
                    padding: EdgeInsets.fromLTRB(
                      Adaptor.width(10),
                      0,
                      Adaptor.width(10),
                      Adaptor.width(14),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${log.timestamp}',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: Adaptor.sp(15),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: Adaptor.width(2),
                                  ),
                                  child: Text(
                                    '+${log.voucher}',
                                    style: TextStyle(
                                      color: Color(0xffFF421A),
                                      fontSize: Adaptor.sp(17),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '代金券',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(12),
                                    color: Colors.black12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: Adaptor.width(2)),
                                  child: Text(
                                    '-${log.coupon}',
                                    style: TextStyle(
                                      color: Color(0xffFF421A),
                                      fontSize: Adaptor.sp(17),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '积分',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(12),
                                    color: Colors.black12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        );
    }
    return List()
      ..add(
        Container(
          margin: EdgeInsets.only(
            top: Adaptor.width(22),
            bottom: Adaptor.width(22),
          ),
          child: EmptyView(
            icon: 'assets/images/empty.png',
            message: '没有兑换记录',
            callback: () {},
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
