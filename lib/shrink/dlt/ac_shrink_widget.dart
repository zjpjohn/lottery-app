import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class AcShrinkWidget extends StatefulWidget {
  Function(AcShrink) onSelected;

  AcShrinkWidget({@required this.onSelected});

  @override
  AcShrinkWidgetState createState() => new AcShrinkWidgetState();
}

class AcShrink {
  ///已选择的ac值
  ///
  List<int> acs = List();

  ///ac值过滤器
  bool filter(List<int> balls) {
    if (acs.length == 0) {
      return true;
    }
    Set<int> deltas = Set();
    for (int i = balls.length - 1; i >= 1; i--) {
      for (int j = i - 1; j >= 0; j--) {
        int delta = balls[i] - balls[j];
        deltas.add(delta);
      }
    }
    return acs.contains(deltas.length - 4);
  }
}

class AcShrinkWidgetState extends State<AcShrinkWidget> {
  ///已选择的ac值
  ///
  AcShrink model = AcShrink();

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
                    "AC值选择",
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
                      if (model.acs.length > 0) {
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
            _buildAcContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAcContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(10), Adaptor.width(30), 0, 0),
      child: Wrap(
        runSpacing: Adaptor.width(15),
        children: _buildAcItems(),
      ),
    );
  }

  List<Widget> _buildAcItems() {
    List<Widget> views = List();
    for (int i = 0; i <= 9; i++) {
      views.add(
        ClipButton(
          text: '$i',
          value: i,
          width: Adaptor.width(45),
          height: Adaptor.width(25),
          selected: model.acs.contains(i) ? 1 : 0,
          onTap: (selected, value) {
            setState(() {
              if (selected == 0) {
                model.acs.add(value);
              } else {
                model.acs.remove(value);
              }
            });
          },
        ),
      );
    }
    return views;
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
