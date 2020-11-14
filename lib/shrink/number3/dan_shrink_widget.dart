import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class DanShrinkWidget extends StatefulWidget {
  DanShrinkWidget({
    Key key,
    @required this.onSelected,
  }) : super(key: key);

  ///选择事件
  ///
  final Function(DanShrink) onSelected;

  @override
  DanShrinkWidgetState createState() => new DanShrinkWidgetState();
}

class DanShrink {
  ///选择的胆码数据
  ///
  Map<int, List<int>> dans = Map();

  ///选择的出号的个数
  ///
  Map<int, List<int>> numbers = Map();

  ///过滤数据
  ///
  ///@param balls
  bool filter(List<int> balls) {
    List<int> keys = dans.keys.toList();

    ///没有胆码条件
    if (keys == null || keys.length == 0) {
      return true;
    }

    for (int i = 0; i < keys.length; i++) {
      int key = keys[i];
      List<int> number = numbers[key];
      if (number == null || number.length == 0) {
        continue;
      }

      ///求号码与胆码的交集
      Set intersection = Set.of(dans[key]).intersection(Set.of(balls));
      if (number.contains(intersection.length)) {
        return true;
      }
    }
    return false;
  }
}

class DanShrinkWidgetState extends State<DanShrinkWidget>
    with SingleTickerProviderStateMixin {
  ///已选择的数据
  ///
  DanShrink model = DanShrink();

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
                    "胆码选择",
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
                      ///删除没有选择胆码个数的胆码条件
                      List<int> keys = List();
                      model.dans.keys.forEach((key) {
                        List<int> number = model.numbers[key];
                        if (number == null || number.length == 0) {
                          keys.add(key);
                        }
                      });
                      if (keys.length > 0) {
                        keys.forEach((key) => model.dans.remove(key));
                      }
                      if (model.dans.length > 0) {
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildDanGroup(1),
                    Constant.line,
                    _buildDanGroup(2),
                    Constant.line,
                    _buildDanGroup(3),
                    Constant.line,
                    _buildDanGroup(4),
                    Constant.line,
                    _buildDanGroup(5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///构建胆码组
  ///
  Widget _buildDanGroup(int index) {
    return Container(
      child: Column(
        children: <Widget>[
          _directBalls('胆码组', index),
          _ballNumbers('出号个数', index),
        ],
      ),
    );
  }

  Widget _directBalls(String name, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(6), Adaptor.width(16), 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(22),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '$name$index',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              children: Constant.balls.map((item) {
                Widget view = _ballD(item, index);
                return view;
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _ballNumbers(String name, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(6),
        Adaptor.width(8),
        0,
        Adaptor.width(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(18),
            padding: EdgeInsets.only(right: Adaptor.width(5)),
            alignment: Alignment.center,
            child: Text(
              '$name',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              children: <Widget>[
                ClipButton(
                    text: '1',
                    value: 1,
                    width: Adaptor.width(38),
                    height: Adaptor.width(21),
                    margin: Adaptor.width(13),
                    selected: (model.numbers[index] != null &&
                            model.numbers[index].contains(1))
                        ? 1
                        : 0,
                    disable: !(model.dans[index] != null &&
                        model.dans[index].length >= 1),
                    onTap: (selected, value) {
                      setState(() {
                        List<int> items = model.numbers[index];
                        if (items == null) {
                          items = List();
                          model.numbers[index] = items;
                        }
                        if (items.contains(value)) {
                          items.remove(value);
                        } else {
                          items.add(value);
                        }
                      });
                    }),
                ClipButton(
                    text: '2',
                    value: 2,
                    width: Adaptor.width(38),
                    height: Adaptor.width(21),
                    margin: Adaptor.width(13),
                    selected: (model.numbers[index] != null &&
                            model.numbers[index].contains(2))
                        ? 1
                        : 0,
                    disable: !(model.dans[index] != null &&
                        model.dans[index].length >= 2),
                    onTap: (selected, value) {
                      setState(() {
                        List<int> items = model.numbers[index];
                        if (items == null) {
                          items = List();
                          model.numbers[index] = items;
                        }
                        if (items.contains(value)) {
                          items.remove(value);
                        } else {
                          items.add(value);
                        }
                      });
                    }),
                ClipButton(
                    text: '3',
                    value: 3,
                    width: Adaptor.width(38),
                    height: Adaptor.width(21),
                    selected: (model.numbers[index] != null &&
                            model.numbers[index].contains(3))
                        ? 1
                        : 0,
                    disable: !(model.dans[index] != null &&
                        model.dans[index].length >= 3),
                    onTap: (selected, value) {
                      setState(() {
                        List<int> items = model.numbers[index];
                        if (items == null) {
                          items = List();
                          model.numbers[index] = items;
                        }
                        if (items.contains(value)) {
                          items.remove(value);
                        } else {
                          items.add(value);
                        }
                      });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _ballD(int name, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(6), Adaptor.width(6)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            List<int> items = model.dans[index];
            if (items == null) {
              items = List();
              model.dans[index] = items;
            }
            if (items.contains(name)) {
              items.remove(name);
            } else {
              items.add(name);
            }
          });
        },
        child: Container(
          height: Adaptor.width(23),
          width: Adaptor.width(23),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: model.dans[index] != null && model.dans[index].contains(name)
                ? Colors.redAccent
                : Color(0xffececec),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Adaptor.width(14)),
          ),
          child: Text(
            '$name',
            style: TextStyle(
              fontSize: Adaptor.sp(12),
              color:
                  model.dans[index] != null && model.dans[index].contains(name)
                      ? Colors.white
                      : Colors.black54,
            ),
          ),
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
