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
import 'package:lottery_app/model/charge_info.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class RechargePage extends StatefulWidget {
  @override
  RechargePageState createState() => new RechargePageState();
}

class RechargePageState extends State<RechargePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider<ChargeModel>(
        create: (_) => ChargeModel.initialize(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              NavAppBar(
                title: '充值中心',
                fontColor: Color(0xFF59575A),
                color: Color(0xFFF9F9F9),
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
              Consumer<ChargeModel>(builder:
                  (BuildContext context, ChargeModel model, Widget child) {
                return _buildView(model);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildView(ChargeModel model) {
    if (model.loaded) {
      if (model.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                model.loadChargeInfos();
              }),
            ],
          ),
        );
      }
      return Expanded(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: Adaptor.height(56)),
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: Consumer<ChargeModel>(builder:
                    (BuildContext context, ChargeModel model, Widget child) {
                  return ListView(
                    padding: EdgeInsets.only(top: 0),
                    physics: EasyRefreshPhysics(topBouncing: false),
                    children: <Widget>[
                      _buildChargeLevel(model),
                      _buildPays(model),
                      _buildNotice(),
                    ],
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              child: GestureDetector(
                onTap: () {
                  model.chargeAction(success: () {
                    AppNavigator.goBack(context, true);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: Adaptor.height(56),
                  color: Color(0xffFF421A).withOpacity(0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        model.paying ? '正在支付' : '立即充值',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Adaptor.sp(20),
                          letterSpacing: 2,
                        ),
                      ),
                      if (model.paying)
                        Padding(
                          padding: EdgeInsets.only(left: Adaptor.width(6)),
                          child: SpinKitRing(
                            color: Colors.white,
                            lineWidth: Adaptor.width(1.2),
                            size: Adaptor.width(20),
                          ),
                        )
                    ],
                  ),
                ),
              ),
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

  Widget _buildChargeLevel(ChargeModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.fromLTRB(0, Adaptor.width(25), 0, Adaptor.width(10)),
            padding: EdgeInsets.only(left: Adaptor.width(15)),
            alignment: Alignment.centerLeft,
            child: Text(
              '充值金额',
              style: TextStyle(
                  fontSize: Adaptor.sp(18),
                  color: Color(0xff3f3f3f),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Wrap(
            spacing: Adaptor.width(25),
            runSpacing: Adaptor.width(15),
            children: <Widget>[]
              ..addAll(model.charges.map((v) => _buildLevel(model, v))),
          )
        ],
      ),
    );
  }

  Widget _buildLevel(ChargeModel model, ChargeInfo level) {
    return GestureDetector(
      onTap: () {
        model.charge = level;
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.42,
            margin: EdgeInsets.only(top: Adaptor.width(6)),
            padding: EdgeInsets.only(
                top: Adaptor.width(14), bottom: Adaptor.width(14)),
            decoration: BoxDecoration(
                color: model.charge != null &&
                        model.charge.levelId == level.levelId
                    ? Color(0xffFDF1D9)
                    : Colors.white,
                borderRadius: BorderRadius.circular(Adaptor.width(3)),
                border: Border.all(
                  color: model.charge != null &&
                          model.charge.levelId == level.levelId
                      ? Color(0xffD9C483)
                      : Color(0xffEFEFEE),
                  width: 1.0,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '¥${level.amount}元',
                  style: TextStyle(
                      color: Color(0xffF1CA61),
                      fontSize: Adaptor.sp(24),
                      fontWeight: FontWeight.w600,
                      height: 0.98),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Adaptor.width(10)),
                  child: Text(
                    '${level.valence}金币',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: Adaptor.sp(12),
                      height: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: level.voucher > 0
                ? Container(
                    padding: EdgeInsets.only(
                      left: Adaptor.width(6),
                      right: Adaptor.width(6),
                      top: Adaptor.width(1.5),
                      bottom: Adaptor.width(1.5),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffCA13E7).withOpacity(0.90),
                        Color(0xff6D17E8).withOpacity(0.90)
                      ]),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Adaptor.width(3)),
                        topRight: Radius.circular(Adaptor.width(3)),
                      ),
                    ),
                    child: Text(
                      '赠${level.voucher}代金券',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adaptor.sp(10),
                      ),
                    ),
                  )
                : Container(
                    child: null,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPays(ChargeModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.fromLTRB(0, Adaptor.width(24), 0, Adaptor.width(8)),
            padding: EdgeInsets.only(left: Adaptor.width(15)),
            alignment: Alignment.centerLeft,
            child: Text(
              '支付方式',
              style: TextStyle(
                  fontSize: Adaptor.width(18),
                  color: Color(0xff3f3f3f),
                  fontWeight: FontWeight.w500),
            ),
          )
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

  Widget _buildNotice() {
    return new Container(
      margin: EdgeInsets.only(top: Adaptor.width(24)),
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        0,
        Adaptor.width(10),
        Adaptor.width(10),
      ),
      child: Column(
        children: <Widget>[
          new Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: Adaptor.width(10)),
            child: Text(
              '温馨提示',
              style: TextStyle(
                color: Colors.grey,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          _buildNoticeItem(1, '充值购买的金币仅限于查看本应用专家收费预测资讯。'),
          _buildNoticeItem(2, '充值兑换规则：1元人民币兑换10金币以及赠送部分代金券。'),
          _buildNoticeItem(3, '对于本系统的收费功能会消耗账户金币以及代金券。'),
          _buildNoticeItem(4, '充值获赠的代金券可以搭配账户金币使用，您可以在【我的账户】查看获取的代金券。'),
          _buildNoticeItem(5, '充值金额一经售出不可退换，充值金币可无限期消费，直至用完为止。'),
          _buildNoticeItem(6, '充值兑换规则以及赠送代金券解释权过西安佐未佑来有限公司所有。'),
          _buildNoticeItem(7, '充值后账户余额长时间无变化，请记录您的账户名致电系统客户查询充值结果。'),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(int index, String notice) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: Adaptor.width(8)),
      child: Text(
        '$index、$notice',
        style: TextStyle(fontSize: Adaptor.sp(12), color: Colors.grey),
        softWrap: true,
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
