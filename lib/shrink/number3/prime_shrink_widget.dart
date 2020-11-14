import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class PrimeShrinkWidget extends StatefulWidget {
  ///选择事件
  ///
  final Function(PrimeShrink) onSelected;

  final int type;

  PrimeShrinkWidget({Key key, @required this.type, @required this.onSelected})
      : super(key: key);

  @override
  PrimeShrinkWidgetState createState() => new PrimeShrinkWidgetState();
}

class PrimeShrink {
  ///选号类型
  int type;

  ///已选择的质合比值
  ///
  Map<int, String> ratios = Map();

  ///已选择质合趋势
  ///
  Map<int, String> trends = Map();

  ///可选择的质合形态
  List<int> trendable = List();

  bool filter(List<int> balls) {
    ///判断奇偶比
    int ratio = calcRatio(balls);
    if (!ratios.containsKey(ratio)) {
      return false;
    }

    ///直选情况
    if (type == 0 && trends.length > 0) {
      int trend = calcTrend(balls);
      if (!trends.containsKey(trend)) {
        return false;
      }
    }
    return true;
  }

  /**
   * 计算奇偶形态：单选形式
   */
  int calcTrend(List<int> balls) {
    String trend = '';
    balls.forEach((ball) {
      if (_compositeList.contains(ball)) {
        trend += '合';
      } else if (_primeList.contains(ball)) {
        trend += '质';
      }
    });
    return prime_trend_map[trend];
  }

  /**
   * 计算质合比
   */
  int calcRatio(List<int> balls) {
    int prime = 0, composite = 0;
    balls.forEach((ball) {
      if (_primeList.contains(ball)) {
        prime++;
      } else if (_compositeList.contains(ball)) {
        composite++;
      }
    });
    return prime_ratio_map['$prime:$composite'];
  }
}

///指数集合
Set<int> _primeList = Set.from([1, 2, 3, 5, 7]);

///合数集合
Set<int> _compositeList = Set.from([4, 6, 8, 9]);

///奇偶比与奇偶形态映射关系
///
const Map<int, List<int>> prime_group = {
  0: [7],
  1: [3, 5, 6],
  2: [1, 2, 4],
  3: [0],
};

const Map<int, String> prime_ratio_list = {
  0: '0:3',
  1: '1:2',
  2: '2:1',
  3: '3:0',
};

const Map<String, int> prime_ratio_map = {
  '0:3': 0,
  '1:2': 1,
  '2:1': 2,
  '3:0': 3,
};

const Map<int, String> prime_trend_list = {
  0: '质质质',
  1: '质质合',
  2: '质合质',
  3: '质合合',
  4: '合质质',
  5: '合质合',
  6: '合合质',
  7: '合合合',
};

const Map<String, int> prime_trend_map = {
  '质质质': 0,
  '质质合': 1,
  '质合质': 2,
  '质合合': 3,
  '合质质': 4,
  '合质合': 5,
  '合合质': 6,
  '合合合': 7,
};

class PrimeShrinkWidgetState extends State<PrimeShrinkWidget> {
  ///质合选择的数据
  ///
  PrimeShrink model = PrimeShrink();

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
                    "质合选择",
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
            _buildPrimeRatio(),
            if (model.type == 0) _buildPrimeTrend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimeRatio() {
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
              '质合比值',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              children: prime_ratio_list.entries
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
                            model.trendable.addAll(prime_group[value]);
                          } else {
                            model.ratios.remove(value);
                            prime_group[value].forEach((item) {
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

  Widget _buildPrimeTrend() {
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
              '质合形态',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(10),
              children: prime_trend_list.entries
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
