import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class BigShrinkWidget extends StatefulWidget {
  ///选择事件
  ///
  final Function(BigShrink) onSelected;

  final int type;

  BigShrinkWidget({Key key, @required this.type, this.onSelected})
      : super(key: key);

  @override
  BigShrinkWidgetState createState() => new BigShrinkWidgetState();
}

class BigShrink {
  ///选号类型
  ///
  int type;

  ///选择的比值数据
  ///
  Map<int, String> ratios = Map();

  ///选择的大小形态
  ///
  Map<int, String> trends = Map();

  ///可选择的大小形态
  List<int> trendable = List();

  ///大小过滤
  bool filter(List<int> balls) {
    ///判断大小比
    int ratio = calcRatio(balls);
    if (!ratios.containsKey(ratio)) {
      return false;
    }

    ///直选情况
    if (type == 0 && trends.length > 0) {
      ///直选形态判断
      int trend = calcTrend(balls);
      if (!trends.containsKey(trend)) {
        return false;
      }
    }
    return true;
  }

  /**
   * 计算大小形态：单选形式
   */
  int calcTrend(List<int> balls) {
    String trend = '';
    balls.forEach((ball) {
      if (ball >= 5) {
        trend += '大';
      } else {
        trend += '小';
      }
    });
    return big_trend_map[trend];
  }

  /**
   * 计算大小比
   */
  int calcRatio(List<int> balls) {
    int big = 0, small = 0;
    balls.forEach((ball) {
      if (ball >= 5) {
        big++;
      } else {
        small++;
      }
    });
    return big_ratio_map['$big:$small'];
  }
}

///大小比与大小形态映射关系
///
const Map<int, List<int>> group = {
  0: [7],
  1: [3, 5, 6],
  2: [1, 2, 4],
  3: [0],
};

///奇偶比与奇偶形态映射关系
///
const Map<int, List<int>> big_group = {
  0: [7],
  1: [3, 5, 6],
  2: [1, 2, 4],
  3: [0],
};

const Map<int, String> big_ratio_list = {
  0: '0:3',
  1: '1:2',
  2: '2:1',
  3: '3:0',
};

const Map<String, int> big_ratio_map = {
  '0:3': 0,
  '1:2': 1,
  '2:1': 2,
  '3:0': 3,
};

const Map<int, String> big_trend_list = {
  0: '大大大',
  1: '大大小',
  2: '大小大',
  3: '大小小',
  4: '小大大',
  5: '小大小',
  6: '小小大',
  7: '小小小',
};

const Map<String, int> big_trend_map = {
  '大大大': 0,
  '大大小': 1,
  '大小大': 2,
  '大小小': 3,
  '小大大': 4,
  '小大小': 5,
  '小小大': 6,
  '小小小': 7,
};

class BigShrinkWidgetState extends State<BigShrinkWidget> {
  ///已选择的数据
  ///
  BigShrink model = BigShrink();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Adaptor.width(5.0)),
        topRight: Radius.circular(Adaptor.width(5.0)),
      ),
      child: Container(
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
                    "大小选择",
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
            _buildBigSmallRatio(),
            if (model.type == 0) _buildBigSmallTrend(),
          ],
        ),
      ),
    );
  }

  Widget _buildBigSmallRatio() {
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
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '大小比值',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              children: big_ratio_list.entries
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
                            model.trendable.addAll(big_group[value]);
                          } else {
                            model.ratios.remove(value);
                            big_group[value].forEach((item) {
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

  Widget _buildBigSmallTrend() {
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
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '大小形态',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(15),
              children: big_trend_list.entries
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
