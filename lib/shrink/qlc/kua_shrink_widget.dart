import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class KuaShrinkWidget extends StatefulWidget {
  Function(KuaShrink) onSelected;

  KuaShrinkWidget({@required this.onSelected});

  @override
  KuaShrinkWidgetState createState() => new KuaShrinkWidgetState();
}

class KuaShrink {
  ///选择的跨度值
  ///
  Set<int> kuas = Set();

  bool filter(List<int> balls) {
    int min = 30, max = 1;
    balls.forEach((item) {
      if (min > item) {
        min = item;
      }
      if (max < item) {
        max = item;
      }
    });
    if (!kuas.contains(max - min)) {
      return false;
    }
    return true;
  }
}

class KuaShrinkWidgetState extends State<KuaShrinkWidget> {
  ///跨度选择
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
                          fontSize: 17,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Constant.line,
            _buildKuaContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildKuaContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(10), Adaptor.width(30), 0, 0),
      child: Wrap(
        runSpacing: Adaptor.width(15),
        children: _buildKuaItems(),
      ),
    );
  }

  List<Widget> _buildKuaItems() {
    List<Widget> views = List();
    for (int i = 6; i <= 29; i++) {
      views.add(
        ClipButton(
            text: '$i',
            value: i,
            width: Adaptor.width(45),
            height: Adaptor.width(24),
            selected: model.kuas.contains(i) ? 1 : 0,
            onTap: (selected, value) {
              setState(() {
                if (selected == 0) {
                  model.kuas.add(value);
                } else {
                  model.kuas.remove(value);
                }
              });
            }),
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
