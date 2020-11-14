import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/ball_button.dart';
import 'package:lottery_app/model/pl3_forecast.dart';
import 'package:provider/provider.dart';

class Pl3ForecastPage extends StatefulWidget {
  String period;

  Pl3ForecastPage({@required this.period});

  @override
  Pl3ForecastPageState createState() => new Pl3ForecastPageState();
}

class Pl3ForecastPageState extends State<Pl3ForecastPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider(
        create: (_) => Pl3ForecastModel(widget.period),
        child: Scaffold(
          body: Consumer(builder:
              (BuildContext context, Pl3ForecastModel model, Widget child) {
            return Column(
              children: <Widget>[
                NavAppBar(
                  title: '排列三预测',
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
                _buildForecastView(model),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildForecastView(Pl3ForecastModel model) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildDanView(model),
            _buildKillView(model),
            _buildCombView(model),
            _buildResultView(model),
          ],
        ),
      ),
    );
  }

  Widget _buildDanView(Pl3ForecastModel model) {
    return Offstage(
      offstage: model.step != 0,
      child: Container(
        margin: EdgeInsets.only(
          left: Adaptor.width(16),
          right: Adaptor.width(16),
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
                    TextSpan(text: '请确定'),
                    TextSpan(
                      text: '7',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: '个胆码，先选出最可能出现的号码，再选择次能出现的号码，以此类推'),
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
                    TextSpan(text: '您已选了'),
                    TextSpan(
                      text: '${model.dan.length}',
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
                  '${_ballJoin(model.dan)}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(18),
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
            _buildDanBall(model),
            Container(
              margin: EdgeInsets.only(top: Adaptor.width(24)),
              child: GestureDetector(
                onTap: () {
                  if (model.dan.length < 7) {
                    EasyLoading.showToast('请先选7个胆码');
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDanBall(Pl3ForecastModel model) {
    List<Widget> views =
        List.from(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).map((v) {
      return BallButton(
        value: v,
        size: 42,
        fontSize: 18,
        status: model.dan.contains(v) ? 1 : 0,
        onTap: (ball) {
          if (model.dan.contains(v)) {
            model.removeDan(v);
          } else {
            model.addDan(
                ball: v,
                overflow: (message) {
                  EasyLoading.showToast(message);
                });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: views.sublist(0, 5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Adaptor.width(8),
              left: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: views.sublist(5, 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKillView(Pl3ForecastModel model) {
    return Offstage(
      offstage: model.step != 1,
      child: Container(
        margin: EdgeInsets.only(
          left: Adaptor.width(16),
          right: Adaptor.width(16),
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
                      text: '2',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: '个杀码号码，先选出最不可能出现的号码，再选择次不能出现的号码')
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
                      text: '${model.kill.length}',
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
                  '${_ballJoin(model.kill)}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(18),
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
            _buildKillBall(model),
            Container(
              margin: EdgeInsets.only(top: Adaptor.width(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      model.step = 0;
                      model.clearKill();
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
                      if (model.kill.length < 2) {
                        EasyLoading.showToast('请先选2个号码');
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

  Widget _buildKillBall(Pl3ForecastModel model) {
    List<Widget> views =
        List.from(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).map((v) {
      return BallButton(
        value: v,
        size: 42,
        fontSize: 18,
        status: model.dan.contains(v) ? -1 : (model.kill.contains(v) ? 1 : 0),
        onTap: (ball) {
          if (model.kill.contains(v)) {
            model.removeKill(v);
          } else {
            model.addKill(
                ball: v,
                overflow: (message) {
                  EasyLoading.showToast(message);
                });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: views.sublist(0, 5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Adaptor.width(8),
              top: Adaptor.width(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: views.sublist(5, 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombView(Pl3ForecastModel model) {
    return Offstage(
      offstage: model.step != 2,
      child: Container(
        margin: EdgeInsets.only(
          left: Adaptor.width(16),
          right: Adaptor.width(16),
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
                    TextSpan(text: '请选出百位十位个位上最可能出现的'),
                    TextSpan(
                      text: '5',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(text: '个数字，先选出最可能出现的号码，再选择次可能出现的号码，以此类推'),
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
                    TextSpan(text: '百位选出'),
                    TextSpan(
                      text: '${model.comb[0].length}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    TextSpan(text: '个号码,十位选出'),
                    TextSpan(
                      text: '${model.comb[1].length}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    TextSpan(text: '个号码,个位选出'),
                    TextSpan(
                      text: '${model.comb[2].length}',
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
                  '${_combJoin(model)}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(18),
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
            _buildCombBall(model),
            Container(
              margin: EdgeInsets.only(top: Adaptor.width(24)),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: Adaptor.width(50),
                    child: null,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          model.step = 1;
                          model.clearComb();
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
                            '重选杀码',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: Adaptor.sp(14),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (model.comb[0].length < 5 ||
                              model.comb[1].length < 5 ||
                              model.comb[2].length < 5) {
                            EasyLoading.showToast('个十百位各选5个号码');
                            return;
                          }
                          model.step = 3;
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _ballJoin(List<String> dans) {
    String target;
    dans.forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  String _combJoin(Pl3ForecastModel model) {
    String b, s, g;

    ///百位
    model.comb[0].forEach((v) {
      b == null ? b = v : b = b + ' ' + v;
    });

    ///十位
    model.comb[1].forEach((v) {
      s == null ? s = v : s = s + ' ' + v;
    });

    ///个位
    model.comb[2].forEach((v) {
      g == null ? g = v : g = g + ' ' + v;
    });
    String target;
    b == null ? target = null : target = b;
    if (s != null) {
      target == null ? target = s : target = target + ' * ' + s;
    }
    if (g != null) {
      target == null ? target = g : target = target + ' * ' + g;
    }
    return target == null ? '' : target;
  }

  Widget _buildCombIndex(Pl3ForecastModel model, int index, String title) {
    List<Widget> views =
        List.from(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).map((v) {
      return BallButton(
        value: v,
        size: 42,
        fontSize: 18,
        status: model.kill.contains(v)
            ? -1
            : (model.comb[index].contains(v) ? 1 : 0),
        onTap: (ball) {
          if (model.comb[index].contains(v)) {
            model.removeComb(index, v);
          } else {
            model.addComb(
                ball: v,
                index: index,
                overflow: (message) {
                  EasyLoading.showToast(message);
                });
          }
        },
      );
    }).toList();
    return Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: Adaptor.height(90),
            width: Adaptor.width(50),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/head_bar.png'),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: Adaptor.sp(12),
                color: Colors.redAccent,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: views.sublist(0, 5),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: views.sublist(5, 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCombBall(Pl3ForecastModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: Adaptor.width(16),
            ),
            child: _buildCombIndex(model, 0, '百位'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(16)),
            child: _buildCombIndex(model, 1, '十位'),
          ),
          _buildCombIndex(model, 2, '个位'),
        ],
      ),
    );
  }

  Widget _buildResultView(Pl3ForecastModel model) {
    return Offstage(
      offstage: model.step != 3,
      child: Container(
        margin: EdgeInsets.all(Adaptor.width(24)),
        alignment: Alignment.topLeft,
        child: model.hasData()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _resultItemView('独胆', _ballJoin(model.dan.sublist(0, 1))),
                  _resultItemView('双胆', _ballJoin(model.dan.sublist(0, 2))),
                  _resultItemView('三胆', _ballJoin(model.dan.sublist(0, 3))),
                  _resultItemView('组合五码', _ballJoin(model.dan.sublist(0, 5))),
                  _resultItemView('组合六码', _ballJoin(model.dan.sublist(0, 6))),
                  _resultItemView('组合七码', _ballJoin(model.dan.sublist(0, 7))),
                  _resultItemView('杀一码', _ballJoin(model.kill.sublist(0, 1))),
                  _resultItemView('杀二码', _ballJoin(model.kill.sublist(0, 2))),
                  _resultItemView('定位三码', _comb(model, 3)),
                  _resultItemView('定位四码', _comb(model, 4)),
                  _resultItemView('定位五码', _comb(model, 5)),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: Adaptor.width(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            model.step = 2;
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

  String _comb(Pl3ForecastModel model, int limit) {
    return '${_ballJoin(model.comb[0].sublist(0, limit))} * ${_ballJoin(model.comb[1].sublist(0, limit))} * ${_ballJoin(model.comb[2].sublist(0, limit))}';
  }

  Widget _resultItemView(String name, String data) {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(6)),
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
                fontSize: Adaptor.sp(17),
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
  void didUpdateWidget(Pl3ForecastPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
