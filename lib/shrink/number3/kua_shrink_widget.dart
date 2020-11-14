import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class KuaShrinkWidget extends StatefulWidget {
  final Function(KuaShrink) onSelected;

  KuaShrinkWidget({Key key, this.onSelected}) : super(key: key);

  @override
  KuaShrinkWidgetState createState() => new KuaShrinkWidgetState();
}

class KuaShrink {
  ///选择的跨度数据
  ///
  Set<int> kuas = Set();

  ///跨度过滤
  bool filter(List<int> balls) {
    int min = 9, max = 0;
    balls.forEach((ball) {
      if (min > ball) {
        min = ball;
      }
      if (max < ball) {
        max = ball;
      }
    });
    return kuas.contains(max - min);
  }
}

class KuaShrinkWidgetState extends State<KuaShrinkWidget> {
  ///已选择的跨度数据
  ///
  KuaShrink model = KuaShrink();

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
                    "跨度选择",
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
                      if (model.kuas.length > 0) {
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
            _buildShrinkContainer(),
            _buildAllAndClear(),
          ],
        ),
      ),
    );
  }

  ///构建和值选择组件
  ///
  Widget _buildShrinkContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(10), Adaptor.width(30), 0, 0),
      alignment: Alignment.center,
      child: Wrap(
        runSpacing: Adaptor.width(15),
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        children: _kuaItemWidget(),
      ),
    );
  }

  List<Widget> _kuaItemWidget() {
    List<Widget> views = List();
    for (int i = 0; i <= 9; i++) {
      views.add(
        ClipButton(
          text: '$i',
          width: Adaptor.width(38),
          height: Adaptor.width(24),
          selected: model.kuas.contains(i) ? 1 : 0,
          value: i,
          onTap: (selected, index) {
            if (selected == 0) {
              model.kuas.add(index);
            } else {
              model.kuas.remove(index);
            }
          },
        ),
      );
    }
    return views;
  }

  Set<int> _selectAll() {
    Set<int> all = Set();
    for (int i = 0; i <= 9; i++) {
      all.add(i);
    }
    return all;
  }

  ///全选和清理组件
  ///
  Widget _buildAllAndClear() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(15), Adaptor.width(18), 0, 0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                model.kuas.addAll(_selectAll());
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: Adaptor.width(15)),
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(15),
                Adaptor.width(4),
                Adaptor.width(15),
                Adaptor.width(4),
              ),
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '全选',
                style: TextStyle(
                  color: Colors.black54,
                  height: 0.95,
                  fontSize: Adaptor.sp(14),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                model.kuas.clear();
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: Adaptor.width(15)),
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(15),
                Adaptor.width(4),
                Adaptor.width(15),
                Adaptor.width(4),
              ),
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '清理',
                style: TextStyle(
                  color: Colors.black54,
                  height: 0.95,
                  fontSize: Adaptor.sp(14),
                ),
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
}
