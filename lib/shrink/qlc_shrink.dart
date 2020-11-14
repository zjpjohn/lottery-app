import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/right_bottom_clipper.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/vip_navigator.dart';
import 'package:lottery_app/shrink/dialog/qlc_lottery_view.dart';
import 'package:lottery_app/shrink/model/qlc_shrink_filter.dart';
import 'package:lottery_app/shrink/qlc/ac_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/dan_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/kua_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/pattern_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/series_shrink_widget.dart';
import 'package:lottery_app/shrink/qlc/sum_shrink_widget.dart';

class QlcShrinkPage extends StatefulWidget {
  @override
  QlcShrinkPageState createState() => new QlcShrinkPageState();
}

class QlcShrinkPageState extends State<QlcShrinkPage> {
  ///七乐彩缩水过滤器
  QlcShrinkFilter filter = QlcShrinkFilter();

  ///已选择的缩水条件
  ///
  Set<int> shrinks = Set();

  ///当前选择的缩水条件
  ///
  int shrink;

  ///是否加载完成
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            MAppBar('缩水计算'),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (loaded) {
      return Expanded(
        child: SingleChildScrollView(
          physics: EasyRefreshPhysics(topBouncing: false),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: Adaptor.width(16),
                  bottom: Adaptor.width(8),
                ),
                child: VipNavigator(),
              ),
              Container(
                margin: EdgeInsets.only(top: Adaptor.width(8)),
                child: Constant.header(
                  '选择号码',
                  0xe698,
                  size: 15,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Adaptor.width(8)),
                child: _buildQlcBall(),
              ),
              Constant.header(
                '缩水条件',
                0xe698,
                size: 15,
              ),
              _buildShrinkTool(),
              Constant.header(
                '已选缩水条件',
                0xe698,
                size: 15,
              ),
              _buildShrinkCondition(),
            ],
          ),
        ),
      );
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Constant.loading(),
        ],
      ),
    );
  }

  Widget _buildQlcBall() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(10),
        0,
        Adaptor.width(5),
      ),
      child: Wrap(
        children: Constant.qlc.map((item) => _ball(item)).toList(),
      ),
    );
  }

  Widget _ball(int ball) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        0,
        0,
        Adaptor.width(8),
        Adaptor.width(10),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (filter.balls.contains(ball)) {
              filter.balls.remove(ball);
            } else {
              filter.balls.add(ball);
            }
          });
        },
        child: Container(
          height: Adaptor.width(25),
          width: Adaptor.width(25),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filter.balls.contains(ball)
                ? Colors.redAccent
                : Color(0xffececec),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Adaptor.width(14)),
          ),
          child: Text(
            '$ball',
            style: TextStyle(
              fontSize: Adaptor.width(12),
              color:
                  filter.balls.contains(ball) ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShrinkTool() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        0,
        Adaptor.width(12),
        0,
        Adaptor.width(4),
      ),
      child: Wrap(
        spacing: Adaptor.width(12),
        runSpacing: Adaptor.width(5),
        children: <Widget>[
          _buildShrinkToolItem(
            '胆码',
            1,
            margin: EdgeInsets.only(
              bottom: Adaptor.width(12),
            ),
            callback: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return DanShrinkWidget(
                    onSelected: (shrink) {
                      setState(() {
                        filter.danFilter = shrink;
                      });
                    },
                  );
                },
              );
            },
          ),
          _buildShrinkToolItem(
            '号码形态',
            2,
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            callback: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adaptor.width(5.0)),
                    topRight: Radius.circular(Adaptor.width(5.0)),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return PatternShrinkWidget(
                    onSelected: (shrink) {
                      setState(() {
                        filter.patternFilter = shrink;
                      });
                    },
                  );
                },
              );
            },
          ),
          _buildShrinkToolItem(
            '和值',
            3,
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            callback: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adaptor.width(5.0)),
                    topRight: Radius.circular(Adaptor.width(5.0)),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SumShrinkWidget(
                    onSelected: (shrink) {
                      setState(() {
                        filter.sumFilter = shrink;
                      });
                    },
                  );
                },
              );
            },
          ),
          _buildShrinkToolItem(
            '跨度',
            4,
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            callback: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adaptor.width(5.0)),
                    topRight: Radius.circular(Adaptor.width(5.0)),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return KuaShrinkWidget(
                    onSelected: (shrink) {
                      setState(() {
                        filter.kuaFilter = shrink;
                      });
                    },
                  );
                },
              );
            },
          ),
          _buildShrinkToolItem(
            'AC值',
            5,
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            callback: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adaptor.width(5.0)),
                    topRight: Radius.circular(Adaptor.width(5.0)),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AcShrinkWidget(
                    onSelected: (shrink) {
                      setState(() {
                        filter.acFilter = shrink;
                      });
                    },
                  );
                },
              );
            },
          ),
          _buildShrinkToolItem(
            '连号',
            6,
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            callback: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adaptor.width(5.0)),
                    topRight: Radius.circular(Adaptor.width(5.0)),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SeriesShrinkWidget(
                    onSelected: (shrink) {
                      setState(() {
                        filter.seriesFilter = shrink;
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  ///创建缩水工具
  ///
  Widget _buildShrinkToolItem(
    String name,
    int index, {
    EdgeInsets margin,
    Function callback,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shrink = index;
          shrinks.add(index);
        });
        callback();
      },
      child: Container(
        height: Adaptor.width(28),
        width: Adaptor.width(70),
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xfff1f1f1),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Adaptor.width(2)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              child: Text(
                '$name',
                style: TextStyle(
                  color: shrinks.contains(index)
                      ? Colors.redAccent
                      : Colors.black54,
                  fontSize: Adaptor.sp(13),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Offstage(
                offstage: shrink != index,
                child: ClipPath(
                  clipper: RightBottomCliper(),
                  child: Container(
                    height: Adaptor.width(28),
                    width: Adaptor.width(28),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(Adaptor.width(2)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShrinkCondition() {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(30)),
      child: Column(
        children: <Widget>[
          _buildDanShrink(),
          _buildKuaShrink(),
          _buildACShrink(),
          _buildSeriesShrink(),
          _buildSumShrink(),
          _buildPatternShrink(),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Offstage(
      offstage: filter.nullFilter(),
      child: Container(
        margin: EdgeInsets.fromLTRB(Adaptor.width(15), Adaptor.width(15), 0, 0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(Adaptor.width(5)),
                        child: QlcLotteryView(
                          filter: filter,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  Adaptor.width(8),
                  Adaptor.width(6),
                  Adaptor.width(8),
                  Adaptor.width(6),
                ),
                margin: EdgeInsets.only(right: Adaptor.width(15)),
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(
                    Adaptor.width(2),
                  ),
                ),
                child: Text(
                  '缩水计算',
                  style: TextStyle(
                    fontSize: Adaptor.width(13),
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.resetFilter();
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  Adaptor.width(8),
                  Adaptor.width(6),
                  Adaptor.width(8),
                  Adaptor.width(6),
                ),
                decoration: BoxDecoration(
                    color: Color(0xfff1f1f1),
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  '清除条件',
                  style: TextStyle(
                    fontSize: Adaptor.width(13),
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _danBall(int ball) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(5), 0),
      child: Container(
        height: Adaptor.width(20),
        width: Adaptor.width(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Adaptor.width(14)),
        ),
        child: Text(
          '$ball',
          style: TextStyle(
            fontSize: Adaptor.sp(11),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDanShrink() {
    if (filter.danFilter != null &&
        filter.danFilter.dans.length > 0 &&
        filter.danFilter.numbers.length > 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(15),
          Adaptor.width(8),
          0,
          Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffececec),
              width: Adaptor.width(0.5),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: Adaptor.width(24),
              width: Adaptor.width(58),
              alignment: Alignment.centerLeft,
              child: Text(
                '胆码条件',
                style: TextStyle(
                  fontSize: Adaptor.width(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0,
                    0,
                    Adaptor.width(5),
                    0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: Adaptor.width(8)),
                        child: Row(
                          children: filter.danFilter.dans
                              .map((ball) => _danBall(ball))
                              .toList(),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: filter.danFilter.numbers
                            .map(
                              (num) => Container(
                                height: Adaptor.width(20),
                                width: Adaptor.width(32),
                                margin:
                                    EdgeInsets.only(right: Adaptor.width(6)),
                                color: Color(0xfff2f2f2),
                                alignment: Alignment.center,
                                child: Text(
                                  '$num',
                                  style: TextStyle(
                                    fontSize: Adaptor.width(13),
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.danFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                    Adaptor.width(10), 0, Adaptor.width(15), 0),
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.circular(Adaptor.width(2.0)),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.width(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  Widget _buildPatternShrink() {
    if (filter.patternFilter != null) {
      List<Widget> views = List();
      if (filter.patternFilter.bigs.length > 0) {
        views.add(
          Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '大 小 比',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filter.patternFilter.bigs.entries
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(5)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.value}',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (filter.patternFilter.evens.length > 0) {
        views.add(
          Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '奇 偶 比',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filter.patternFilter.evens.entries
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(5)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.value}',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (filter.patternFilter.primes.length > 0) {
        views.add(
          Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '质 合 比',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filter.patternFilter.primes.entries
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(5)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.value}',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (filter.patternFilter.road0.length > 0) {
        views.add(
          Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '0路个数',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filter.patternFilter.road0
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(5)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '$item',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (filter.patternFilter.road1.length > 0) {
        views.add(
          Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '1路个数',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filter.patternFilter.road1
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(5)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '$item',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (filter.patternFilter.road2.length > 0) {
        views.add(
          Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '2路个数',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filter.patternFilter.road2
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(5)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '$item',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(15),
          Adaptor.width(8),
          0,
          Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffececec),
              width: Adaptor.width(0.5),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: views,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.patternFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.circular(Adaptor.width(2.0)),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.sp(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  Widget _buildSumShrink() {
    if (filter.sumFilter != null) {
      List<Widget> views = List();
      views.add(
        Container(
          margin: EdgeInsets.only(bottom: Adaptor.width(2)),
          child: Row(
            children: <Widget>[
              Container(
                height: Adaptor.width(24),
                width: Adaptor.width(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  '和值范围',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black38,
                  ),
                ),
              ),
              Container(
                height: Adaptor.width(22),
                width: Adaptor.width(60),
                margin: EdgeInsets.only(right: Adaptor.width(5)),
                color: Color(0xfff2f2f2),
                alignment: Alignment.center,
                child: Text(
                  '${filter.sumFilter.value.start.toInt()}—${filter.sumFilter.value.end.toInt()}',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      if (filter.sumFilter.oddEven.length > 0 ||
          filter.sumFilter.roads.length > 0) {
        views.add(
          Container(
            margin: EdgeInsets.only(bottom: Adaptor.width(2)),
            child: Row(
              children: <Widget>[
                Container(
                  height: Adaptor.width(24),
                  width: Adaptor.width(58),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '和值形态',
                    style: TextStyle(
                      fontSize: Adaptor.sp(12),
                      color: Colors.black38,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List()
                        ..addAll(
                          filter.sumFilter.oddEven
                              .map(
                                (item) => Container(
                                  height: Adaptor.width(20),
                                  width: Adaptor.width(36),
                                  margin:
                                      EdgeInsets.only(right: Adaptor.width(5)),
                                  color: Color(0xfff2f2f2),
                                  alignment: Alignment.center,
                                  child: Text(
                                    item == 1 ? '奇数' : '偶数',
                                    style: TextStyle(
                                      fontSize: Adaptor.width(12),
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                        ..addAll(
                          filter.sumFilter.roads
                              .map(
                                (item) => Container(
                                  height: Adaptor.width(20),
                                  width: Adaptor.width(36),
                                  margin:
                                      EdgeInsets.only(right: Adaptor.width(5)),
                                  color: Color(0xfff2f2f2),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$item路',
                                    style: TextStyle(
                                      fontSize: Adaptor.sp(12),
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (filter.sumFilter.tail.length > 0) {
        views.add(
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: Adaptor.width(24),
                  width: Adaptor.width(58),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '和值尾数',
                    style: TextStyle(
                      fontSize: Adaptor.sp(12),
                      color: Colors.black38,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filter.sumFilter.tail
                          .map(
                            (item) => Container(
                              height: Adaptor.width(20),
                              width: Adaptor.width(36),
                              margin: EdgeInsets.only(right: Adaptor.width(5)),
                              color: Color(0xfff2f2f2),
                              alignment: Alignment.center,
                              child: Text(
                                '$item',
                                style: TextStyle(
                                  fontSize: Adaptor.sp(12),
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Container(
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(15),
          Adaptor.width(8),
          0,
          Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffececec),
              width: Adaptor.width(0.5),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: views,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.sumFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.circular(Adaptor.width(2.0)),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.width(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  Widget _buildKuaShrink() {
    if (filter.kuaFilter != null && filter.kuaFilter.kuas.length > 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(15),
          Adaptor.width(8),
          0,
          Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffececec),
              width: Adaptor.width(0.5),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              width: Adaptor.width(58),
              alignment: Alignment.centerLeft,
              child: Text(
                '跨度条件',
                style: TextStyle(
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0,
                    0,
                    Adaptor.width(5),
                    0,
                  ),
                  child: Row(
                    children: filter.kuaFilter.kuas
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(32),
                            margin: EdgeInsets.only(right: Adaptor.width(6)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '$item',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.kuaFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.circular(Adaptor.width(2.0)),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.width(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  Widget _buildACShrink() {
    if (filter.acFilter != null && filter.acFilter.acs.length > 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(15),
          Adaptor.width(8),
          0,
          Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffececec),
              width: Adaptor.width(0.5),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              width: Adaptor.width(58),
              alignment: Alignment.centerLeft,
              child: Text(
                'AC值条件',
                style: TextStyle(
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0,
                    0,
                    Adaptor.width(5),
                    0,
                  ),
                  child: Row(
                    children: filter.acFilter.acs
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(32),
                            margin: EdgeInsets.only(right: Adaptor.width(6)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '$item',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.acFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.circular(
                    Adaptor.width(2.0),
                  ),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.width(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  Widget _buildSeriesShrink() {
    if (filter.seriesFilter != null && filter.seriesFilter.series.length > 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(15),
          Adaptor.width(8),
          0,
          Adaptor.width(8),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Color(0xffececec), width: Adaptor.width(0.5)),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              width: Adaptor.width(58),
              alignment: Alignment.centerLeft,
              child: Text(
                '连号条件',
                style: TextStyle(
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0,
                    0,
                    Adaptor.width(5),
                    0,
                  ),
                  child: Row(
                    children: filter.seriesFilter.series.entries
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(48),
                            margin: EdgeInsets.only(right: Adaptor.width(6)),
                            color: Color(0xfff2f2f2),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.value}',
                              style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  filter.seriesFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.circular(Adaptor.width(2.0)),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.width(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
