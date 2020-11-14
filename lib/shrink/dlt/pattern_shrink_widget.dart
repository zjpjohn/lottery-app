import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class PatternShrinkWidget extends StatefulWidget {
  Function(PatternShrink) onSelected;

  PatternShrinkWidget({@required this.onSelected});

  @override
  PatternShrinkWidgetState createState() => new PatternShrinkWidgetState();
}

const List<int> roads = [0, 1, 2, 3, 4, 5];

///大小球
Set<int> SMALL_BALL =
    Set.of([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]);
Set<int> BIG_BALL = Set.of(
    [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]);

Map<int, String> BIG_SMALL = {
  0: '0:5',
  1: '1:4',
  2: '2:3',
  3: '3:2',
  4: '4:1',
  5: '5:0',
};

Map<String, int> BIG_MAP = {
  '0:5': 0,
  '1:4': 1,
  '2:3': 2,
  '3:2': 3,
  '4:1': 4,
  '5:0': 5,
};

///奇偶号
Set<int> ODD_BALL =
    Set.of([1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35]);
Set<int> EVEN_BALL =
    Set.of([2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34]);
Map<int, String> ODD_EVEN = {
  0: '0:5',
  1: '1:4',
  2: '2:3',
  3: '3:2',
  4: '4:1',
  5: '5:0',
};

Map<String, int> ODD_MAP = {
  '0:5': 0,
  '1:4': 1,
  '2:3': 2,
  '3:2': 3,
  '4:1': 4,
  '5:0': 5,
};

///质合数
Set<int> PRIME_BALL = Set.of([1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]);
Set<int> COM_BALL = Set.of([
  4,
  6,
  8,
  9,
  10,
  12,
  14,
  15,
  16,
  18,
  20,
  21,
  22,
  24,
  25,
  26,
  27,
  28,
  30,
  32,
  33,
  34,
  35
]);

Map<int, String> PRIME_COMPOSITE = {
  0: '0:5',
  1: '1:4',
  2: '2:3',
  3: '3:2',
  4: '4:1',
  5: '5:0',
};

Map<String, int> PRIME_MAP = {
  '0:5': 0,
  '1:4': 1,
  '2:3': 2,
  '3:2': 3,
  '4:1': 4,
  '5:0': 5,
};

///0-1-2数
Set<int> ROAD0 = Set.of([3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33]);
Set<int> ROAD1 = Set.of([1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]);
Set<int> ROAD2 = Set.of([2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35]);

class PatternShrink {
  ///已选择的大小比
  ///
  Map<int, String> bigs = Map();

  ///已选择的奇偶比
  ///
  Map<int, String> evens = Map();

  ///已选择的质合比
  ///
  Map<int, String> primes = Map();

  ///已选择的0-1-2的数据
  ///
  Set<int> road0 = Set();
  Set<int> road1 = Set();
  Set<int> road2 = Set();

  ///形态过滤器
  bool filter(List<int> balls) {
    ///大小比过滤
    if (bigs.length > 0) {
      int big = BIG_BALL.intersection(Set.of(balls)).length;
      int small = 5 - big;
      if (!bigs.containsKey(BIG_MAP['$big:$small'])) {
        return false;
      }
    }

    ///奇偶比过滤
    if (evens.length > 0) {
      int odd = ODD_BALL.intersection(Set.of(balls)).length;
      int even = 5 - odd;
      if (!evens.containsKey(ODD_MAP['$odd:$even'])) {
        return false;
      }
    }

    ///质合比过滤
    if (primes.length > 0) {
      int prime = PRIME_BALL.intersection(Set.of(balls)).length;
      int composite = 5 - prime;
      if (!primes.containsKey(PRIME_MAP['$prime:$composite'])) {
        return false;
      }
    }

    ///0路过滤
    if (road0.length > 0) {
      int r0 = ROAD0.intersection(Set.of(balls)).length;
      if (!road0.contains(r0)) {
        return false;
      }
    }

    ///1路过滤
    if (road1.length > 0) {
      int r1 = ROAD1.intersection(Set.of(balls)).length;
      if (!road1.contains(r1)) {
        return false;
      }
    }

    ///2路过滤
    if (road2.length > 0) {
      int r2 = ROAD2.intersection(Set.of(balls)).length;
      if (!road2.contains(r2)) {
        return false;
      }
    }
    return true;
  }
}

class PatternShrinkWidgetState extends State<PatternShrinkWidget> {
  ///已选择的数据
  ///
  PatternShrink model = PatternShrink();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
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
                    "号码形态",
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
                      if (model.bigs.length > 0 ||
                          model.evens.length > 0 ||
                          model.primes.length > 0 ||
                          model.road0.length > 0 ||
                          model.road1.length > 0 ||
                          model.road2.length > 0) {
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
            _buildBigSmall(),
            _buildOddEven(),
            _buildPrime(),
            _buildRoad012(),
          ],
        ),
      ),
    );
  }

  Widget _buildBigSmall() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(20),
        0,
        Adaptor.width(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '大 小 比',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(10),
              children: BIG_SMALL.entries
                  .map(
                    (entry) => ClipButton(
                        text: '${entry.value}',
                        value: entry.key,
                        width: Adaptor.width(44),
                        height: Adaptor.width(24),
                        selected: model.bigs.containsKey(entry.key) ? 1 : 0,
                        onTap: (selected, value) {
                          setState(() {
                            if (selected == 0) {
                              model.bigs.putIfAbsent(value, () => entry.value);
                            } else {
                              model.bigs.remove(value);
                            }
                          });
                        }),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOddEven() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(10),
        0,
        Adaptor.width(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '奇 偶 比',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(10),
              children: ODD_EVEN.entries
                  .map(
                    (entry) => ClipButton(
                        text: '${entry.value}',
                        value: entry.key,
                        width: Adaptor.width(44),
                        height: Adaptor.width(24),
                        selected: model.evens.containsKey(entry.key) ? 1 : 0,
                        onTap: (selected, value) {
                          setState(() {
                            if (selected == 0) {
                              model.evens
                                  .putIfAbsent(entry.key, () => entry.value);
                            } else {
                              model.evens.remove(value);
                            }
                          });
                        }),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrime() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(10),
        0,
        Adaptor.width(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
            alignment: Alignment.center,
            child: Text(
              '质 合 比',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              runSpacing: Adaptor.width(10),
              children: PRIME_COMPOSITE.entries
                  .map(
                    (entry) => ClipButton(
                        text: '${entry.value}',
                        value: entry.key,
                        width: Adaptor.width(44),
                        height: Adaptor.width(24),
                        selected: model.primes.containsKey(entry.key) ? 1 : 0,
                        onTap: (selected, value) {
                          setState(() {
                            if (selected == 0) {
                              model.primes
                                  .putIfAbsent(entry.key, () => entry.value);
                            } else {
                              model.primes.remove(value);
                            }
                          });
                        }),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoad012() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildRoadItem(0),
          _buildRoadItem(1),
          _buildRoadItem(2),
        ],
      ),
    );
  }

  Widget _buildRoadItem(int index) {
    Set<int> road;
    switch (index) {
      case 0:
        road = model.road0;
        break;
      case 1:
        road = model.road1;
        break;
      case 2:
        road = model.road2;
        break;
    }
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(10),
        0,
        Adaptor.width(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Adaptor.width(20),
            padding: EdgeInsets.only(right: Adaptor.width(8)),
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
              runSpacing: Adaptor.width(10),
              children: roads
                  .map(
                    (item) => ClipButton(
                        text: '$item',
                        value: item,
                        width: Adaptor.width(44),
                        height: Adaptor.width(24),
                        selected: road.contains(item) ? 1 : 0,
                        onTap: (selected, value) {
                          setState(() {
                            if (selected == 0) {
                              road.add(value);
                            } else {
                              road.remove(value);
                            }
                          });
                        }),
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
