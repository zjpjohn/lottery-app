import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class PatternShrinkWidget extends StatefulWidget {
  ///选择事件
  ///
  final Function(PatternShrink) onSelected;

  PatternShrinkWidget({Key key, this.onSelected}) : super(key: key);

  @override
  PatternShrinkWidgetState createState() => new PatternShrinkWidgetState();
}

class PatternShrink {
  ///已选择的形态
  Map<int, String> pattern = Map();

  ///已选择的连号形态
  ///
  Map<int, String> series = Map();

  ///形态过滤
  bool filter(List<int> balls) {
    ///号码形态判断：组六-3,组三-2,豹子-1
    if (pattern.length > 0 && pattern.length < 3) {
      Set distinct = Set.from(balls);
      if (!pattern.containsKey(distinct.length)) {
        return false;
      }
    }

    ///连号判断
    ///
    ///差值集合
    if (series.length > 0 && series.length < 3) {
      Set<int> minus = Set();
      for (int i = 0; i < balls.length - 1; i++) {
        int from = balls[i];
        for (int j = i + 1; j < balls.length; j++) {
          int target = balls[j];
          minus.add((from - target).abs());
        }
      }

      ///计算连号情况
      int serval = calcSeries(minus);
      if (!series.containsKey(serval)) {
        return false;
      }
    }

    return true;
  }

  int calcSeries(Set<int> minus) {
    int min = 9, max = 0;
    minus.forEach((v) {
      if (min > v) {
        min = v;
      }
      if (max < v) {
        max = v;
      }
    });

    //二连号
    if ((min == 1 && minus.length == 3) || (min == 0 && max == 1)) {
      return 1;
    }

    ///三连号
    if ((min == 1 && minus.length == 2)) {
      return 2;
    }

    ///无连号
    return 0;
  }
}

class PatternShrinkWidgetState extends State<PatternShrinkWidget> {
  ///已选择的数据
  ///
  PatternShrink model = PatternShrink();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Adaptor.width(5.0)),
        topRight: Radius.circular(Adaptor.width(5.0)),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 11.0 / 16.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Adaptor.width(14.0)),
                  child: Text(
                    "形态选择",
                    style: TextStyle(
                      fontSize: Adaptor.sp(17),
                      color: Colors.black54,
                    ),
                  ),
                ),
                Positioned(
                  left: Adaptor.width(14),
                  top: Adaptor.width(14),
                  bottom: Adaptor.width(14),
                  child: InkWell(
                    onTap: () {
                      AppNavigator.goBack(context);
                    },
                    child: Container(
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: Adaptor.sp(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: Adaptor.width(16),
                  top: Adaptor.width(14),
                  bottom: Adaptor.width(14),
                  child: InkWell(
                    onTap: () {
                      if (model.pattern.length > 0 || model.series.length > 0) {
                        widget.onSelected(model);
                      }
                      AppNavigator.goBack(context);
                    },
                    child: Container(
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: Adaptor.sp(17),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Constant.line,
            _buildPatternContainer(),
            _buildSeriesContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(8),
        Adaptor.width(40),
        0,
        Adaptor.width(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipButton(
              text: '组六型',
              value: 3,
              width: Adaptor.width(66),
              height: Adaptor.width(28),
              margin: Adaptor.width(35),
              selected: model.pattern.containsKey(3) ? 1 : 0,
              onTap: (selected, value) {
                setState(() {
                  if (selected == 0) {
                    model.pattern[value] = '组六型';
                  } else {
                    model.pattern.remove(value);
                  }
                });
              }),
          ClipButton(
              text: '组三型',
              value: 2,
              width: Adaptor.width(66),
              height: Adaptor.width(28),
              margin: Adaptor.width(35),
              selected: model.pattern.containsKey(2) ? 1 : 0,
              onTap: (selected, value) {
                setState(() {
                  if (selected == 0) {
                    model.pattern[value] = '组三型';
                  } else {
                    model.pattern.remove(value);
                  }
                });
              }),
          ClipButton(
              text: '豹子型',
              value: 1,
              width: Adaptor.width(66),
              height: Adaptor.width(28),
              margin: 0,
              selected: model.pattern.containsKey(1) ? 1 : 0,
              onTap: (selected, value) {
                setState(() {
                  if (selected == 0) {
                    model.pattern[value] = '豹子型';
                  } else {
                    model.pattern.remove(value);
                  }
                });
              }),
        ],
      ),
    );
  }

  Widget _buildSeriesContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(8),
        Adaptor.width(10),
        0,
        Adaptor.width(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipButton(
              text: '无连号',
              value: 0,
              width: Adaptor.width(66),
              height: Adaptor.width(28),
              margin: Adaptor.width(35),
              selected: model.series.containsKey(0) ? 1 : 0,
              onTap: (selected, value) {
                setState(() {
                  if (selected == 0) {
                    model.series[value] = '无连号';
                  } else {
                    model.series.remove(value);
                  }
                });
              }),
          ClipButton(
              text: '二连号',
              value: 1,
              width: Adaptor.width(66),
              height: Adaptor.width(28),
              margin: Adaptor.width(35),
              selected: model.series.containsKey(1) ? 1 : 0,
              onTap: (selected, value) {
                setState(() {
                  if (selected == 0) {
                    model.series[value] = '二连号';
                  } else {
                    model.series.remove(value);
                  }
                });
              }),
          ClipButton(
              text: '三连号',
              value: 2,
              width: Adaptor.width(66),
              height: Adaptor.width(28),
              margin: 0,
              selected: model.series.containsKey(2) ? 1 : 0,
              onTap: (selected, value) {
                setState(() {
                  if (selected == 0) {
                    model.series[value] = '三连号';
                  } else {
                    model.series.remove(value);
                  }
                });
              }),
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
}
