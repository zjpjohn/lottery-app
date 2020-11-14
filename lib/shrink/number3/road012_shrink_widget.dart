import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class Road012ShrinkWidget extends StatefulWidget {
  final Function(Road012Shrink) onSelected;

  Road012ShrinkWidget({Key key, @required this.onSelected}) : super(key: key);

  @override
  Road012ShrinkWidgetState createState() => new Road012ShrinkWidgetState();
}

class Road012Shrink {
  List<int> roads0 = List();

  List<int> roads1 = List();

  List<int> roads2 = List();

  ///012路过滤
  bool filter(List<int> balls) {
    ///0路判断
    int road0 = calcRoadX(balls, 0);
    //0路有限制
    if (roads0.length > 0) {
      if (!roads0.contains(road0)) {
        return false;
      }
    }

    ///1路判断
    int road1 = calcRoadX(balls, 1);
    //1路有限制
    if (roads1.length > 0) {
      if (!roads1.contains(road1)) {
        return false;
      }
    }

    ///2路判断
    int road2 = calcRoadX(balls, 2);
    //0路有限制
    if (roads2.length > 0) {
      if (!roads2.contains(road2)) {
        return false;
      }
    }
    return true;
  }

  int calcRoadX(List<int> balls, int road) {
    int count = 0;
    balls.forEach((ball) {
      if (ball % 3 == road) {
        count++;
      }
    });
    return count;
  }
}

class Road012ShrinkWidgetState extends State<Road012ShrinkWidget> {
  ///选择的数据
  ///
  Road012Shrink model = Road012Shrink();

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
                    "012路选择",
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
                      if (model.roads0.length > 0 ||
                          model.roads1.length > 0 ||
                          model.roads2.length > 0) {
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
            _build012RoadContainer(),
          ],
        ),
      ),
    );
  }

  ///构建012路组件
  ///
  Widget _build012RoadContainer() {
    return Container(
      margin: EdgeInsets.only(top: Adaptor.width(10)),
      child: Column(
        children: <Widget>[
          _build012Item(0),
          _build012Item(1),
          _build012Item(2),
        ],
      ),
    );
  }

  Widget _build012Item(int index) {
    List<int> road;
    switch (index) {
      case 0:
        road = model.roads0;
        break;
      case 1:
        road = model.roads1;
        break;
      case 2:
        road = model.roads2;
        break;
    }
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(15), Adaptor.width(15), 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(24),
            padding: EdgeInsets.only(right: Adaptor.width(15)),
            alignment: Alignment.center,
            child: Text(
              '$index路个数',
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
                    text: '0',
                    value: 0,
                    width: Adaptor.width(48),
                    height: Adaptor.width(26),
                    margin: Adaptor.width(13),
                    selected: road.contains(0) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          road.add(value);
                        } else {
                          road.remove(value);
                        }
                      });
                    }),
                ClipButton(
                    text: '1',
                    value: 1,
                    width: Adaptor.width(48),
                    height: Adaptor.width(26),
                    margin: Adaptor.width(13),
                    selected: road.contains(1) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          road.add(value);
                        } else {
                          road.remove(value);
                        }
                      });
                    }),
                ClipButton(
                    text: '2',
                    value: 2,
                    width: Adaptor.width(48),
                    height: Adaptor.width(26),
                    margin: Adaptor.width(13),
                    selected: road.contains(2) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          road.add(value);
                        } else {
                          road.remove(value);
                        }
                      });
                    }),
                ClipButton(
                    text: '3',
                    value: 3,
                    width: Adaptor.width(48),
                    height: Adaptor.width(26),
                    margin: Adaptor.width(13),
                    selected: road.contains(3) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          road.add(value);
                        } else {
                          road.remove(value);
                        }
                      });
                    }),
              ],
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
