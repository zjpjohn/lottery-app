import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/custome_card.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/animate_number.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/dash_line.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/flip_card.dart';
import 'package:lottery_app/components/sign_widget.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/clipper_views.dart';
import 'package:lottery_app/model/sign_model.dart';
import 'package:provider/provider.dart';
import 'package:lottery_app/components/adaptor.dart';

class SignActivityPage extends StatefulWidget {
  @override
  SignActivityPageState createState() => new SignActivityPageState();
}

class SignActivityPageState extends State<SignActivityPage> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<SignModel>(
        create: (_) => SignModel.initialize(),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                child: ClipPath(
                  clipper: SignClipper(),
                  child: Container(
                    height: Adaptor.height(240),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xFFFE8C00),
                        const Color(0xFFF83600),
                      ]),
                    ),
                    child: null,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  MAppBar('签到 | 活动'),
                  Consumer<SignModel>(builder:
                      (BuildContext context, SignModel model, Widget child) {
                    return _buildView(model);
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildView(SignModel model) {
    if (model.loaded) {
      if (model.error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                model.loaded = false;
                model.loadSignInfo();
              }),
            ],
          ),
        );
      }
      return Expanded(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            physics: EasyRefreshPhysics(topBouncing: false),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(12),
                    Adaptor.width(16),
                    0,
                    0,
                  ),
                  margin: EdgeInsets.only(bottom: Adaptor.width(6)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _showSignRule(model);
                            },
                            child: Container(
                              height: Adaptor.height(28),
                              padding: EdgeInsets.fromLTRB(
                                Adaptor.width(12),
                                0,
                                Adaptor.width(6),
                                0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffFF7648),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Adaptor.width(14)),
                                  bottomLeft:
                                      Radius.circular(Adaptor.width(14)),
                                ),
                              ),
                              child: Text(
                                '签到规则',
                                style: TextStyle(
                                  fontSize: Adaptor.sp(12),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '连签',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adaptor.sp(22),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${model.signInfo.sthrottle}',
                            style: TextStyle(
                              color: Color(0xffF3F748),
                              fontSize: Adaptor.sp(24),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '天',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adaptor.sp(21),
                              height: 1.1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            child: ClipPath(
                              clipper: TopLeftClipper(),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  Adaptor.width(16),
                                  Adaptor.width(2),
                                  Adaptor.width(8),
                                  Adaptor.width(4),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xffFEEBB1),
                                  borderRadius: BorderRadius.circular(
                                    Adaptor.width(2),
                                  ),
                                ),
                                child: Text(
                                  '赢大额积分',
                                  style: TextStyle(
                                    color: Color(0xffFF421A),
                                    fontSize: Adaptor.sp(11),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: _buildSignInfo(model),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Adaptor.width(24)),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, Adaptor.width(15)),
                    child: CCard(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                              0,
                              Adaptor.width(15),
                              0,
                              Adaptor.width(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: Adaptor.width(5)),
                                  child: Text(
                                    '—',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '签到历史',
                                  style: TextStyle(
                                    fontSize: Adaptor.sp(17),
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: Adaptor.width(5)),
                                  child: Text(
                                    '—',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: Adaptor.height(82),
                            margin: EdgeInsets.only(
                              bottom: Adaptor.width(15),
                              left: Adaptor.width(26),
                              right: Adaptor.width(26),
                            ),
                            decoration: ShapeDecoration(
                                color: Color(0xffFFEEE7),
                                shape: HoleShapeBorder()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '签到',
                                  style: TextStyle(
                                    color: Color(0xff88644C),
                                    fontSize: Adaptor.sp(15),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${model.signInfo.total}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: Adaptor.sp(16),
                                  ),
                                ),
                                Text(
                                  '次',
                                  style: TextStyle(
                                    color: Colors.black12,
                                    fontSize: Adaptor.sp(12),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(left: Adaptor.width(8)),
                                  child: AnimateNumber(
                                    number: model.signInfo.coupon,
                                    start: model.signInfo.coupon - 9 < 0
                                        ? 0
                                        : model.signInfo.coupon - 9,
                                    duration: 800,
                                    style: TextStyle(
                                      color: Color(0xffFF421A),
                                      fontSize: Adaptor.sp(24),
                                      fontWeight: FontWeight.w400,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                                Text(
                                  '积分',
                                  style: TextStyle(
                                    color: Colors.black12,
                                    fontSize: Adaptor.sp(12),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: _singLogViews(model),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  List<Widget> _singLogViews(SignModel model) {
    if (model.logs.length > 0) {
      return List()
        ..addAll(
          model.logs
              .map(
                (log) => Container(
                  margin: EdgeInsets.only(
                    left: Adaptor.width(24),
                    right: Adaptor.width(24),
                  ),
                  padding: EdgeInsets.only(
                    left: Adaptor.width(3),
                    right: Adaptor.width(3),
                    top: Adaptor.width(10),
                    bottom: Adaptor.width(10),
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xfff2f2f2),
                        width: Adaptor.width(0.5),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                log.type == 1 ? '每日签到' : '连续签到奖励',
                                style: TextStyle(
                                  color: log.type == 1
                                      ? Color(0xff616161)
                                      : Color(0xffFF421A),
                                  fontSize: Adaptor.sp(14),
                                ),
                              ),
                              Text(
                                '${log.signTime}',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: Adaptor.sp(14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(right: Adaptor.width(2)),
                                child: Text(
                                  '+${log.award}',
                                  style: TextStyle(
                                    color: Color(0xffFF421A),
                                    fontSize: Adaptor.sp(21),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '积分',
                                style: TextStyle(
                                  fontSize: Adaptor.sp(12),
                                  color: Colors.black26,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList()
                ..add(
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: Adaptor.width(12),
                      bottom: Adaptor.width(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: Adaptor.width(4)),
                          child: Icon(
                            IconData(0xe68b, fontFamily: 'iconfont'),
                            size: Adaptor.sp(10),
                            color: Color(0xff88644C).withOpacity(0.4),
                          ),
                        ),
                        Text(
                          '仅显示最近7次的积分明细',
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: Adaptor.sp(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
    }
    return List()
      ..add(
        Padding(
          padding: EdgeInsets.only(
            top: Adaptor.width(16),
            bottom: Adaptor.width(16),
          ),
          child: EmptyView(
            icon: 'assets/images/empty.png',
            message: '没有签到记录',
            size: 82,
            callback: () {},
          ),
        ),
      );
  }

  Widget _buildSignInfo(SignModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(
            Adaptor.width(12),
            0,
            Adaptor.width(12),
            Adaptor.width(10),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Adaptor.width(4)),
          ),
          child: _buildSignView(model),
        ),
      ],
    );
  }

  Widget _buildSignView(SignModel model) {
    return CCard(
      child: Container(
        margin: EdgeInsets.fromLTRB(
          Adaptor.width(8),
          Adaptor.width(12),
          Adaptor.width(8),
          Adaptor.width(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(10),
                0,
                Adaptor.width(10),
                Adaptor.width(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '每日签到',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.sp(14),
                    ),
                  ),
                  Text(
                    model.signInfo.lastSign != null
                        ? '上次签到 ${model.signInfo.lastSign}'
                        : '',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.width(11),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Adaptor.width(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _signCards(model),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                model.signInfo.sthrottle - model.signInfo.series > 0
                    ? '再签${model.signInfo.sthrottle - model.signInfo.series}天将获得积分大奖'
                    : '恭喜您获得积分奖励',
                style: TextStyle(
                  color: model.signInfo.sthrottle - model.signInfo.series > 0
                      ? Colors.black38
                      : Color(0xffFF421A),
                  fontSize: Adaptor.sp(13),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (model.signInfo.hasSigned == 0) {
                  model.signAction(callback: () {
                    cardKey.currentState.toggleCard();
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, Adaptor.width(10), 0, 0),
                alignment: Alignment.center,
                child: Container(
                  height: Adaptor.height(38),
                  width: Adaptor.width(238),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xffFC6E18),
                      Color(0xffFF421A),
                    ]),
                    borderRadius: BorderRadius.circular(Adaptor.width(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        model.signInfo.hasSigned == 0
                            ? (model.signing ? '正在签到' : '立即签到')
                            : '今日已签到',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Adaptor.sp(16),
                        ),
                      ),
                      if (model.signing)
                        Padding(
                          padding: EdgeInsets.only(left: Adaptor.width(6)),
                          child: SpinKitRing(
                            color: Colors.white,
                            lineWidth: Adaptor.width(1.2),
                            size: Adaptor.width(16),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _signCards(SignModel model) {
    List<Widget> cards = List();
    for (int i = 1; i <= model.signInfo.sthrottle; i++) {
      cards.add(
        FlipCard(
          key: i == model.signInfo.lastSeries + 1 ? cardKey : null,
          flipOnTouch: false,
          direction: FlipDirection.HORIZONTAL,
          front: SignCard(
              title: '$i天',
              hasSigned: i <= model.signInfo.lastSeries,
              index: i,
              throttle: model.signInfo.sthrottle),
          back: SignCard(
              title: '$i天',
              hasSigned: i > model.signInfo.lastSeries,
              index: i,
              throttle: model.signInfo.sthrottle),
        ),
      );
    }
    return cards;
  }

  void _showSignRule(SignModel model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: Adaptor.height(300),
                width: Adaptor.width(250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Adaptor.width(6)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: Adaptor.width(15),
                        bottom: Adaptor.width(8),
                      ),
                      child: Text(
                        '签到规则',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: Adaptor.sp(16.5),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Adaptor.width(14),
                        0,
                        Adaptor.width(14),
                        0,
                      ),
                      child: Text(
                        '1、每日签到，用户每天签到都将会获得${model.signInfo.ecoupon}个奖励积分。',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Adaptor.sp(13),
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.none,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Adaptor.sp(14),
                        Adaptor.sp(3),
                        Adaptor.sp(14),
                        0,
                      ),
                      child: Text(
                        '2、连续签到，用户连续签到${model.signInfo.sthrottle}天，将会获得${model.signInfo.scoupon}个大额奖励积分。',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Adaptor.sp(13),
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.none,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Adaptor.sp(14),
                        Adaptor.sp(3),
                        Adaptor.sp(14),
                        0,
                      ),
                      child: Text(
                        '3、签到周期，系统将签到周期设置为${model.signInfo.sthrottle}天，当用户每完成${model.signInfo.sthrottle}天签到，会自动开启新的签到周期。',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Adaptor.sp(13),
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.none,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Adaptor.sp(14),
                        Adaptor.sp(3),
                        Adaptor.sp(14),
                        0,
                      ),
                      child: Text(
                        '4、积分用途，当用户的积分达到一定额度后，用户可以在【我的积分】中将积分兑换成代金券，然后在平台中使用。',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Adaptor.sp(13),
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.none,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: Adaptor.width(1),
                height: Adaptor.width(40),
                color: Colors.white,
              ),
              GestureDetector(
                onTap: () {
                  AppNavigator.goBack(context);
                },
                child: Container(
                  transform: Matrix4.translationValues(0, -Adaptor.width(2), 0),
                  child: Icon(
                    IconData(0xe651, fontFamily: 'iconfont'),
                    size: Adaptor.sp(28),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      },
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
