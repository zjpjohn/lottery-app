import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class SumShrinkWidget extends StatefulWidget {
  Function(SumShrink) onSelected;

  SumShrinkWidget({@required this.onSelected});

  @override
  SumShrinkWidgetState createState() => new SumShrinkWidgetState();
}

class SumShrink {
  ///已选中的值
  ///
  RangeValues value = RangeValues(28, 189);

  ///已选中的和值形态
  ///
  Set<int> oddEven = Set();

  ///和值012路
  ///
  Set<int> roads = Set();

  ///和值尾数
  ///
  Set<int> tail = Set();

  bool filter(List<int> balls) {
    int sum = 0;
    balls.forEach((item) => sum = sum + item);

    ///和值范围判断
    if (value.start > sum && value.end < sum) {
      return false;
    }

    ///和值形态判断
    if (oddEven.length > 0) {
      int mode2 = sum % 2;
      if (!oddEven.contains(mode2)) {
        return false;
      }
    }
    if (roads.length > 0) {
      int mode3 = sum % 3;
      if (!roads.contains(mode3)) {
        return false;
      }
    }

    ///和值尾数判断
    if (tail.length > 0) {
      int stail = null;
      if (sum <= 99) {
        stail = sum % 10;
      } else {
        stail = (sum % 100) % 10;
      }
      if (!tail.contains(stail)) {
        return false;
      }
    }
    return true;
  }
}

class SumShrinkWidgetState extends State<SumShrinkWidget> {
  ///和值已选择的数据
  ///
  SumShrink model = SumShrink();

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
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Adaptor.width(14.0)),
                  child: Text(
                    "和值选择",
                    style: TextStyle(
                      fontSize: Adaptor.sp(17),
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
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
                          fontWeight: FontWeight.w400,
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
                      if (model.roads.length > 0 ||
                          model.oddEven.length > 0 ||
                          model.tail.length > 0) {
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Constant.line,
            _buildSumRange(),
            _buildSumPattern(),
            _buildSumTail(),
          ],
        ),
      ),
    );
  }

  Widget _buildSumRange() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        0,
        Adaptor.width(30),
        0,
        Adaptor.width(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(Adaptor.width(10), 0, 0, 0),
            child: Text(
              '和值范围',
              style: TextStyle(
                fontSize: Adaptor.sp(12),
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            alignment: Alignment.centerLeft,
            child: RangeSlider(
              min: 28,
              max: 189,
              values: model.value,
              divisions: 161,
              activeColor: Colors.redAccent,
              inactiveColor: Colors.red[100],
              labels: RangeLabels(
                  '${model.value.start.floor()}', '${model.value.end.floor()}'),
              onChanged: (RangeValues newValue) {
                setState(() {
                  model.value = newValue;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSumPattern() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(10), 0, 0, Adaptor.width(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '和值形态',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(15),
              children: <Widget>[
                ClipButton(
                  text: '奇数',
                  value: 0,
                  width: Adaptor.width(58),
                  height: Adaptor.width(26),
                  selected: model.oddEven.contains(0) ? 1 : 0,
                  onTap: (selected, value) {
                    setState(() {
                      if (selected == 0) {
                        model.oddEven.add(value);
                      } else {
                        model.oddEven.remove(value);
                      }
                    });
                  },
                ),
                ClipButton(
                  text: '偶数',
                  value: 1,
                  width: Adaptor.width(58),
                  height: Adaptor.width(26),
                  selected: model.oddEven.contains(1) ? 1 : 0,
                  onTap: (selected, value) {
                    setState(() {
                      if (selected == 0) {
                        model.oddEven.add(value);
                      } else {
                        model.oddEven.remove(value);
                      }
                    });
                  },
                ),
                ClipButton(
                  text: '0路',
                  value: 0,
                  width: Adaptor.width(58),
                  height: Adaptor.width(26),
                  selected: model.roads.contains(0) ? 1 : 0,
                  onTap: (selected, value) {
                    setState(() {
                      if (selected == 0) {
                        model.roads.add(value);
                      } else {
                        model.roads.remove(value);
                      }
                    });
                  },
                ),
                ClipButton(
                  text: '1路',
                  value: 1,
                  width: Adaptor.width(58),
                  height: Adaptor.width(26),
                  selected: model.roads.contains(1) ? 1 : 0,
                  onTap: (selected, value) {
                    setState(() {
                      if (selected == 0) {
                        model.roads.add(value);
                      } else {
                        model.roads.remove(value);
                      }
                    });
                  },
                ),
                ClipButton(
                  text: '2路',
                  value: 2,
                  width: Adaptor.width(58),
                  height: Adaptor.width(26),
                  selected: model.roads.contains(2) ? 1 : 0,
                  onTap: (selected, value) {
                    setState(() {
                      if (selected == 0) {
                        model.roads.add(value);
                      } else {
                        model.roads.remove(value);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSumTail() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        0,
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
              '和值尾数',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(14),
              children: Constant.balls
                  .map(
                    (i) => ClipButton(
                      text: '$i',
                      value: i,
                      width: Adaptor.width(44),
                      height: Adaptor.width(24),
                      selected: model.tail.contains(i) ? 1 : 0,
                      onTap: (selected, value) {
                        setState(() {
                          if (selected == 0) {
                            model.tail.add(value);
                          } else {
                            model.tail.remove(value);
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
  }

  @override
  void dispose() {
    super.dispose();
  }
}
