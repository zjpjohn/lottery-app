import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class SumShrinkWidget extends StatefulWidget {
  ///选择事件
  ///
  Function(SumShrink) onSelected;

  SumShrinkWidget({Key key, @required this.onSelected}) : super(key: key);

  @override
  SumShrinkWidgetState createState() => new SumShrinkWidgetState();
}

const List<int> sumList = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
];

class SumShrink {
  ///已选择的数据
  ///
  Set<int> sums = Set();

  ///和值过滤
  bool filter(List<int> balls) {
    int sum = 0;
    balls.forEach((ball) => sum = sum + ball);
    return sums.contains(sum);
  }
}

class SumShrinkWidgetState extends State<SumShrinkWidget> {
  ///已选择的数据
  ///
  Set<int> selects = Set();

  ///已选择的数据
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (model.sums.length > 0) {
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
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(30),
        0,
        0,
      ),
      alignment: Alignment.center,
      child: Wrap(
        runSpacing: Adaptor.width(15),
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        children: _sumItemWidget(),
      ),
    );
  }

  List<Widget> _sumItemWidget() {
    return sumList
        .map((i) => ClipButton(
            text: '$i',
            width: Adaptor.width(38),
            height: Adaptor.width(24),
            selected: model.sums.contains(i) ? 1 : 0,
            value: i,
            onTap: (selected, index) {
              if (selected == 0) {
                model.sums.add(index);
              } else {
                model.sums.remove(index);
              }
            }))
        .toList();
  }

  ///全选和清理组件
  ///
  Widget _buildAllAndClear() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(18),
        0,
        0,
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                model.sums.addAll(sumList);
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
                model.sums.clear();
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
                borderRadius: BorderRadius.circular(Adaptor.width(2)),
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
