import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class DanShrinkWidget extends StatefulWidget {
  ///选择事件
  Function(DltDanShrink) onSelected;

  DanShrinkWidget({@required this.onSelected});

  @override
  DanShrinkWidgetState createState() => new DanShrinkWidgetState();
}

///出号数据范围
const List<int> numbers = [1, 2, 3, 4, 5];

class DltDanShrink {
  ///选择的胆码
  ///
  Set<int> dans = Set();

  ///出号个数
  ///
  List<int> numbers = List();

  ///胆码过滤器
  bool filter(List<int> balls) {
    Set<int> intersection = Set.from(balls).intersection(dans);
    return numbers.contains(intersection.length);
  }
}

class DanShrinkWidgetState extends State<DanShrinkWidget> {
  ///选择的胆码数据
  ///
  DltDanShrink model = DltDanShrink();

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
                    "胆码选择",
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
                      if (model.dans.length > 0 && model.numbers.length > 0) {
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
            _buildDltBall(),
            _buildRemark(),
            _buildBallNumber(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemark() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(15), 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        '(胆码：最大可能的号码，最多可选择6个)',
        style: TextStyle(
          fontSize: Adaptor.sp(14),
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildBallNumber() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(15),
        0,
        Adaptor.width(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.height(22),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '出号个数',
              style: TextStyle(
                height: 0.90,
                color: Colors.black54,
                fontSize: Adaptor.sp(13),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(15),
              children: numbers
                  .map(
                    (item) => ClipButton(
                      text: '$item',
                      value: item,
                      width: Adaptor.width(36),
                      height: Adaptor.height(20),
                      fontSize: Adaptor.sp(13),
                      margin: Adaptor.width(12),
                      selected: model.numbers.contains(item) ? 1 : 0,
                      disable: !(model.dans.length >= item),
                      onTap: (selected, value) {
                        setState(() {
                          if (selected == 0) {
                            model.numbers.add(value);
                          } else {
                            model.numbers.remove(value);
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

  Widget _buildDltBall() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(15),
        0,
        Adaptor.width(5),
      ),
      child: Wrap(
        children: Constant.dlt.map((item) => _ball(item)).toList(),
      ),
    );
  }

  Widget _ball(int ball) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        0,
        0,
        Adaptor.width(10),
        Adaptor.width(10),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (model.dans.contains(ball)) {
              model.dans.remove(ball);
              model.numbers.retainWhere((item) => item > model.dans.length);
            } else {
              if (model.dans.length >= 6) {
                EasyLoading.showToast('最多选择6个');
                return;
              }
              model.dans.add(ball);
            }
          });
        },
        child: Container(
          height: Adaptor.width(28),
          width: Adaptor.width(28),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: model.dans.contains(ball)
                ? Colors.redAccent
                : Color(0xffefefef),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$ball',
            style: TextStyle(
              fontSize: Adaptor.sp(13),
              color: model.dans.contains(ball) ? Colors.white : Colors.black38,
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
