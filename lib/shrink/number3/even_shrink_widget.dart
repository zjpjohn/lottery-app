import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class EvenShrinkWidget extends StatefulWidget {
  final Function(EvenOddShrink) onSelected;

  final int type;

  EvenShrinkWidget({Key key, @required this.type, @required this.onSelected})
      : super(key: key);

  @override
  EvenShrinkWidgetState createState() => new EvenShrinkWidgetState();
}

class EvenOddShrink {
  ///选号类型
  int type;

  ///已选择的奇偶比
  ///
  Map<int, String> ratios = Map();

  ///已选择的奇偶形态
  ///
  Map<int, String> trends = Map();

  ///可选择的奇偶形态
  List<int> trendable = List();

  ///奇偶过滤
  ///
  bool filter(List<int> balls) {
    ///判断奇偶比
    int ratio = calcRatio(balls);
    if (!ratios.containsKey(ratio)) {
      return false;
    }

    ///直选情况
    if (type == 0 && trends.length > 0) {
      int trend = calcTrend(balls);
      if (!trends.containsKey(trend)) {
        return false;
      }
    }
    return true;
  }

  /**
   * 计算奇偶形态：单选形式
   */
  int calcTrend(List<int> balls) {
    String trend = '';
    balls.forEach((ball) {
      if (ball % 2 == 0) {
        trend += '偶';
      } else {
        trend += '奇';
      }
    });
    return odd_trend_map[trend];
  }

  /**
   * 计算奇偶比
   */
  int calcRatio(List<int> balls) {
    int odd = 0, even = 0;
    balls.forEach((ball) {
      if (ball % 2 == 0) {
        even++;
      } else {
        odd++;
      }
    });
    return odd_ratio_map['$odd:$even'];
  }
}

///奇偶比与奇偶形态映射关系
///
const Map<int, List<int>> odd_group = {
  0: [7],
  1: [3, 5, 6],
  2: [1, 2, 4],
  3: [0],
};

const Map<int, String> odd_ratio_list = {
  0: '0:3',
  1: '1:2',
  2: '2:1',
  3: '3:0',
};

const Map<String, int> odd_ratio_map = {
  '0:3': 0,
  '1:2': 1,
  '2:1': 2,
  '3:0': 3,
};

const Map<int, String> odd_trend_list = {
  0: '奇奇奇',
  1: '奇奇偶',
  2: '奇偶奇',
  3: '奇偶偶',
  4: '偶奇奇',
  5: '偶奇偶',
  6: '偶偶奇',
  7: '偶偶偶',
};

const Map<String, int> odd_trend_map = {
  '奇奇奇': 0,
  '奇奇偶': 1,
  '奇偶奇': 2,
  '奇偶偶': 3,
  '偶奇奇': 4,
  '偶奇偶': 5,
  '偶偶奇': 6,
  '偶偶偶': 7,
};

class EvenShrinkWidgetState extends State<EvenShrinkWidget> {
  ///奇偶选择数据
  ///
  EvenOddShrink model = EvenOddShrink();

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
                    "奇偶选择",
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
                      if (model.ratios.length > 0) {
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
            _buildOddEvenRatio(),
            if (model.type == 0) _buildOddEvenTrend(),
          ],
        ),
      ),
    );
  }

  Widget _buildOddEvenRatio() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(8),
        Adaptor.width(30),
        0,
        Adaptor.width(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(24),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '奇偶比值',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              children: odd_ratio_list.entries
                  .map(
                    (entry) => ClipButton(
                      text: entry.value,
                      value: entry.key,
                      width: Adaptor.width(48),
                      height: Adaptor.width(26),
                      selected: model.ratios.containsKey(entry.key) ? 1 : 0,
                      onTap: (selected, value) {
                        setState(() {
                          if (selected == 0) {
                            model.ratios.putIfAbsent(value, () => entry.value);
                            model.trendable.addAll(odd_group[value]);
                          } else {
                            model.ratios.remove(value);
                            odd_group[value].forEach((item) {
                              ///删除可选择的奇偶形态
                              model.trendable.remove(item);

                              ///删除已选择的奇偶形态
                              model.trends.remove(item);
                            });
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOddEvenTrend() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(8),
        Adaptor.width(5),
        0,
        Adaptor.width(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(24),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '奇偶形态',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.width(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(10),
              children: odd_trend_list.entries
                  .map(
                    (entry) => ClipButton(
                      text: entry.value,
                      value: entry.key,
                      width: Adaptor.width(58),
                      height: Adaptor.width(26),
                      fontSize: Adaptor.sp(12),
                      selected: model.trends.containsKey(entry.key) ? 1 : 0,
                      disable: !model.trendable.contains(entry.key),
                      onTap: (selected, value) {
                        setState(() {
                          if (selected == 0) {
                            model.trends.putIfAbsent(value, () => entry.value);
                          } else {
                            model.trends.remove(value);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    model.type = widget.type;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
