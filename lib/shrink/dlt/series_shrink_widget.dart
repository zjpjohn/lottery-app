import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class SeriesShrinkWidget extends StatefulWidget {
  Function(SeriesShrink) onSelected;

  SeriesShrinkWidget({@required this.onSelected});

  @override
  SeriesShrinkWidgetState createState() => new SeriesShrinkWidgetState();
}

const Map<int, String> SERIES = {
  0: '无连号',
  1: '二连号',
  2: '三连号',
  3: '四连号',
  4: '五连号',
};

class SeriesShrink {
  ///已选择的连号
  ///
  Map<int, String> series = Map();

  ///连号过滤器
  bool filter(List<int> balls) {
    Set<int> sCollection = Set();

    ///二连号
    for (int i = 0; i <= balls.length - 2; i++) {
      if (balls[i + 1] - balls[i] == 1) {
        sCollection.add(1);
        break;
      }
    }

    ///三连号
    if (sCollection.contains(1)) {
      for (int i = 0; i <= balls.length - 3; i++) {
        if (balls[i + 2] - balls[i] == 2) {
          sCollection.add(2);
          break;
        }
      }
    }

    ///四连号
    if (sCollection.contains(2)) {
      for (int i = 0; i <= balls.length - 4; i++) {
        if (balls[i + 3] - balls[i] == 3) {
          sCollection.add(3);
          break;
        }
      }
    }

    ///五连号
    if (sCollection.contains(3)) {
      for (int i = 0; i <= balls.length - 5; i++) {
        if (balls[i + 4] - balls[i] == 4) {
          sCollection.add(4);
          break;
        }
      }
    }

    ///没有连号
    if (sCollection.length == 0) {
      sCollection.add(0);
    }
    Set<int> intersection = sCollection.intersection(Set.of(series.keys));
    return intersection.length > 0;
  }
}

class SeriesShrinkWidgetState extends State<SeriesShrinkWidget> {
  ///连号选择的数据
  ///
  SeriesShrink model = SeriesShrink();

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
                    "连号选择",
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
                      if (model.series.length > 0) {
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
            _buildSeriesContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(10), Adaptor.width(30), 0, 0),
      child: Wrap(
        runSpacing: Adaptor.width(15),
        children: SERIES.entries
            .map(
              (entry) => ClipButton(
                text: '${entry.value}',
                width: Adaptor.width(58),
                height: Adaptor.width(28),
                value: entry.key,
                fontSize: Adaptor.sp(12),
                selected: model.series.containsKey(entry.key) ? 1 : 0,
                onTap: (selected, value) {
                  setState(() {
                    if (model.series.containsKey(value)) {
                      model.series.remove(value);
                    } else {
                      model.series.putIfAbsent(value, () => entry.value);
                    }
                  });
                },
              ),
            )
            .toList(),
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
