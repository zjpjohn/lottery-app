import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/ball_button.dart';
import 'package:lottery_app/model/qlc_forecast.dart';
import 'package:provider/provider.dart';

class QlcPredictPage extends StatefulWidget {
  String period;

  QlcPredictPage({@required this.period});

  @override
  QlcPredictPageState createState() => new QlcPredictPageState();
}

class QlcPredictPageState extends State<QlcPredictPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider(
        create: (_) => QlcPredictModel(widget.period),
        child: Scaffold(
          body: Consumer(
            builder:
                (BuildContext context, QlcPredictModel model, Widget child) {
              return Column(
                children: <Widget>[
                  NavAppBar(
                    title: '七乐彩预测',
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
                  _buildQlcForecastView(model),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQlcForecastView(QlcPredictModel model) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildRedView(model),
            _buildRedKillView(model),
            _buildResultView(model),
          ],
        ),
      ),
    );
  }

  Widget _buildRedView(QlcPredictModel model) {
    return Offstage(
      offstage: model.step != 0,
      child: Container(
        margin: EdgeInsets.only(
          left: Adaptor.width(10),
          right: Adaptor.width(10),
          top: Adaptor.width(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: Adaptor.width(12)),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: Adaptor.sp(14),
                  ),
                  children: [
                    TextSpan(
                        text: '请您根据号码出现的可能性由大到小，先选出最可能出现的号码，再选出次可能出现的号码，最终选出'),
                    TextSpan(
                      text: '22',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: '个号码，以此类推'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Adaptor.width(24)),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: Adaptor.sp(12),
                  ),
                  children: [
                    TextSpan(text: '您已选择'),
                    TextSpan(
                      text: '${model.red.length}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    TextSpan(text: '个号码'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: Adaptor.width(16),
              ),
              child: Container(
                height: Adaptor.width(42),
                child: Text(
                  '${model.redJoin(22)}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(18),
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
            _buildRedBall(model),
            Container(
              margin: EdgeInsets.only(top: Adaptor.width(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      model.clearRed();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      height: Adaptor.height(38),
                      margin: EdgeInsets.only(bottom: Adaptor.width(16)),
                      width: Adaptor.width(240),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(
                          Adaptor.width(2),
                        ),
                      ),
                      child: Text(
                        '清空选号',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: Adaptor.sp(14),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (model.red.length < 22) {
                        EasyLoading.showToast('请先选22个号码');
                        return;
                      }
                      model.step = 1;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      height: Adaptor.height(38),
                      width: Adaptor.width(240),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(
                          Adaptor.width(2),
                        ),
                      ),
                      child: Text(
                        '下一步',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: Adaptor.sp(14),
                        ),
                      ),
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

  Widget _buildRedBall(QlcPredictModel model) {
    List<Widget> views = Constant.QLC_BALL.map((v) {
      return BallButton(
        value: v,
        size: 38,
        fontSize: 18,
        status: model.red.contains(v) ? 1 : 0,
        onTap: (ball) {
          if (model.red.contains(v)) {
            model.removeRed(v);
          } else {
            model.addRed(
              ball: v,
              overflow: (message) {
                EasyLoading.showToast(message);
              },
            );
          }
        },
      );
    }).toList();
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Adaptor.width(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(0, 7),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(7, 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(14, 21),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(21, 28),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(28, 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedKillView(QlcPredictModel model) {
    return Offstage(
      offstage: model.step != 1,
      child: Container(
        margin: EdgeInsets.only(
          left: Adaptor.width(10),
          right: Adaptor.width(10),
          top: Adaptor.width(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: Adaptor.width(12)),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: Adaptor.sp(14),
                  ),
                  children: [
                    TextSpan(text: '请选择'),
                    TextSpan(
                      text: '6',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: '个不可能出现的号码，先选出最不可能出现的号码，再选择次不能出现的号码')
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Adaptor.width(24)),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: Adaptor.sp(12),
                  ),
                  children: [
                    TextSpan(text: '您已选择'),
                    TextSpan(
                      text: '${model.redKill.length}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    TextSpan(text: '个号码'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: Adaptor.width(16),
              ),
              child: Container(
                height: Adaptor.width(42),
                child: Text(
                  '${model.redKillJoin(6)}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(18),
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
            _buildRedKillBall(model),
            Container(
              margin: EdgeInsets.only(top: Adaptor.width(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      model.step = 0;
                      model.clearRedKill();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      height: Adaptor.height(38),
                      margin: EdgeInsets.only(bottom: Adaptor.width(16)),
                      width: Adaptor.width(240),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(
                          Adaptor.width(2),
                        ),
                      ),
                      child: Text(
                        '重选胆码',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: Adaptor.sp(14),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (model.redKill.length < 6) {
                        EasyLoading.showToast('请先选6个号码');
                        return;
                      }
                      model.step = 2;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      height: Adaptor.height(38),
                      width: Adaptor.width(240),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(
                          Adaptor.width(2),
                        ),
                      ),
                      child: Text(
                        '下一步',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: Adaptor.sp(14),
                        ),
                      ),
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

  Widget _buildRedKillBall(QlcPredictModel model) {
    List<Widget> views = Constant.QLC_BALL.map((v) {
      return BallButton(
        value: v,
        size: 38,
        fontSize: 18,
        status:
            model.red.contains(v) ? -1 : (model.redKill.contains(v) ? 1 : 0),
        onTap: (ball) {
          if (model.redKill.contains(v)) {
            model.removeRedKill(v);
          } else {
            model.addRedKill(
              ball: v,
              overflow: (message) {
                EasyLoading.showToast(message);
              },
            );
          }
        },
      );
    }).toList();
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Adaptor.width(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(0, 7),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(7, 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(14, 21),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(21, 28),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: views.sublist(28, 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(QlcPredictModel model) {
    return Offstage(
      offstage: model.step != 2,
      child: Container(
        margin: EdgeInsets.all(Adaptor.width(24)),
        alignment: Alignment.topLeft,
        child: model.hasData()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _resultItemView('红球独胆', model.redJoin(1)),
                  _resultItemView('红球双胆', model.redJoin(2)),
                  _resultItemView('红球三胆', model.redJoin(3)),
                  _resultItemView('红球12码', model.redJoin(12)),
                  _resultItemView('红球18码', model.redJoin(18)),
                  _resultItemView('红球22码', model.redJoin(22)),
                  _resultItemView('红球杀三码', model.redKillJoin(3)),
                  _resultItemView('红球杀六码', model.redKillJoin(6)),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: Adaptor.width(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            model.step = 1;
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            alignment: Alignment.center,
                            height: Adaptor.height(38),
                            margin: EdgeInsets.only(bottom: Adaptor.width(16)),
                            width: Adaptor.width(240),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(
                                Adaptor.width(2),
                              ),
                            ),
                            child: Text(
                              '重新选码',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: Adaptor.sp(14),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            model.issueForecast(callback: (result, message) {
                              EasyLoading.showToast(message);
                              if (result) {
                                AppNavigator.goBack(context, true);
                              }
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            alignment: Alignment.center,
                            height: Adaptor.height(38),
                            width: Adaptor.width(240),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(
                                Adaptor.width(2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${model.issuing ? '提交中' : '提交'}',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: Adaptor.sp(14),
                                  ),
                                ),
                                if (model.issuing)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: Adaptor.width(6)),
                                    child: SpinKitRing(
                                      color: Colors.white,
                                      lineWidth: Adaptor.width(1.2),
                                      size: Adaptor.width(15),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Container(
                child: null,
              ),
      ),
    );
  }

  Widget _resultItemView(String name, String data) {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.black38, fontSize: Adaptor.sp(14)),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adaptor.width(2)),
            child: Text(
              data,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: Adaptor.sp(16),
              ),
            ),
          ),
        ],
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

  @override
  void didUpdateWidget(QlcPredictPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
