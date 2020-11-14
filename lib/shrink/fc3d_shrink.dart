import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/right_bottom_clipper.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/vip_navigator.dart';
import 'package:lottery_app/shrink/dialog/number3_lottery_view.dart';
import 'package:lottery_app/shrink/number3/big_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/dan_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/even_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/kua_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/pattern_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/prime_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/road012_shrink_widget.dart';
import 'package:lottery_app/shrink/number3/sum_shrink_widget.dart';
import 'package:lottery_app/shrink/model/number_three_shrink.dart';

class Fc3dShrinkPage extends StatefulWidget {
  @override
  Fc3dShrinkPageState createState() => new Fc3dShrinkPageState();
}

class Fc3dShrinkPageState extends State<Fc3dShrinkPage> {
  ///缩水类型:0-直选,1-组选
  int type = 0;

  ///已选择的缩水条件
  Set<int> shrinks = Set();

  ///当前选中的缩水条件
  int shrink;

  ///缩水条件
  NumberThreeShrink model = NumberThreeShrink();

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
              _buildBallView(),
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

  ///构建缩水类型
  Widget _buildShrinkType() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(10),
        0,
        Adaptor.width(6),
      ),
      child: Row(
        children: <Widget>[
          _buildType('直选', 0),
          _buildType('组选', 1),
        ],
      ),
    );
  }

  Widget _buildType(String title, int index) {
    return Container(
      margin: EdgeInsets.only(right: Adaptor.width(20)),
      child: GestureDetector(
        onTap: () {
          if (type != index) {
            if (type == 0) {
              model.resetDirect();
            } else {
              model.resetCombine();
            }
            setState(() {
              type = index;
              model.type = index;

              ///清空已选择的缩水条件
              model.resetFilter();
            });
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(18),
                0,
                Adaptor.width(18),
                0,
              ),
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Adaptor.width(3)),
              ),
              child: Text(
                '$title',
                style: TextStyle(
                  fontSize: Adaptor.width(13),
                  color: type == index ? Colors.redAccent : Colors.black54,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Offstage(
                offstage: type != index,
                child: ClipPath(
                  clipper: RightBottomCliper(),
                  child: Container(
                    height: Adaptor.width(26),
                    width: Adaptor.width(26),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(Adaptor.width(3)),
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

  Widget _buildBallView() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildShrinkType(),
          Offstage(
            offstage: type != 0,
            child: _buildDirectBall(),
          ),
          Offstage(
            offstage: type != 1,
            child: _buildCombineBall(),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectBall() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(10),
        0,
        Adaptor.width(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(6)),
            child: _directBalls('百位', 0),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(6)),
            child: _directBalls('十位', 1),
          ),
          _directBalls('个位', 2),
          Padding(
            padding: EdgeInsets.only(top: Adaptor.width(6)),
            child: Text(
              '注：点击号码选择排除，再次点击选中',
              style: TextStyle(
                color: Colors.black26,
                fontSize: Adaptor.sp(13),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _directBalls(String name, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(6)),
            child: Text(
              '$name',
              style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(13),
              ),
            ),
          ),
          Wrap(
            children: Constant.balls.map((item) {
              Widget view = _ballD(item, index);
              return view;
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _ballD(int name, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(8), 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (model.directs[index].contains(name)) {
              model.directs[index].remove(name);
            } else {
              model.directs[index].add(name);
            }
          });
        },
        child: Container(
          height: Adaptor.width(25),
          width: Adaptor.width(25),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: model.directs[index] != null &&
                    model.directs[index].contains(name)
                ? Colors.redAccent
                : Color(0xffececec),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Adaptor.width(14)),
          ),
          child: Text(
            '$name',
            style: TextStyle(
              fontSize: Adaptor.sp(13),
              color: model.directs[index].contains(name)
                  ? Colors.white
                  : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ballC(int name) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(8), 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (model.combines.contains(name)) {
              model.combines.remove(name);
            } else {
              model.combines.add(name);
            }
          });
        },
        child: Container(
          height: Adaptor.width(25),
          width: Adaptor.width(25),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: model.combines.contains(name)
                ? Colors.redAccent
                : Color(0xffececec),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$name',
            style: TextStyle(
              fontSize: Adaptor.sp(13),
              color:
                  model.combines.contains(name) ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCombineBall() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(10),
        0,
        Adaptor.width(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            children: Constant.balls.map((item) {
              Widget view = _ballC(item);
              return view;
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adaptor.width(6)),
            child: Text(
              '注：点击号码选择排除，再次点击选中',
              style: TextStyle(
                color: Colors.black26,
                fontSize: Adaptor.sp(13),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShrinkTool() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(16),
        Adaptor.width(12),
        Adaptor.width(16),
        Adaptor.width(12),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildShrinkToolItem(
                name: '胆码',
                index: 1,
                margin: EdgeInsets.only(bottom: Adaptor.width(12)),
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
                            model.danFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              _buildShrinkToolItem(
                name: '和值',
                index: 2,
                margin: EdgeInsets.only(bottom: Adaptor.width(12)),
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
                      return SumShrinkWidget(
                        onSelected: (shrink) {
                          setState(() {
                            model.sumFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              _buildShrinkToolItem(
                name: '跨度',
                index: 3,
                margin: EdgeInsets.only(bottom: Adaptor.width(12)),
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
                      return KuaShrinkWidget(
                        onSelected: (shrink) {
                          setState(() {
                            model.kuaFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              _buildShrinkToolItem(
                name: '奇偶',
                index: 4,
                margin: EdgeInsets.only(bottom: Adaptor.width(12)),
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
                      return EvenShrinkWidget(
                        type: type,
                        onSelected: (shrink) {
                          setState(() {
                            model.evenFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildShrinkToolItem(
                name: '质合',
                index: 5,
                margin: EdgeInsets.only(bottom: Adaptor.width(10)),
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
                      return PrimeShrinkWidget(
                        type: type,
                        onSelected: (shrink) {
                          setState(() {
                            model.primeFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              _buildShrinkToolItem(
                name: '012路',
                index: 6,
                margin: EdgeInsets.only(bottom: Adaptor.width(10)),
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
                      return Road012ShrinkWidget(
                        onSelected: (shrink) {
                          setState(() {
                            model.roadFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              _buildShrinkToolItem(
                name: '大小',
                index: 7,
                margin: EdgeInsets.only(bottom: Adaptor.width(10)),
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
                      return BigShrinkWidget(
                        type: type,
                        onSelected: (shrink) {
                          setState(() {
                            model.bigFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              _buildShrinkToolItem(
                name: '形态',
                index: 8,
                margin: EdgeInsets.only(bottom: Adaptor.width(10)),
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
                      return PatternShrinkWidget(
                        onSelected: (shrink) {
                          setState(() {
                            model.patternFilter = shrink;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///创建缩水工具
  ///
  Widget _buildShrinkToolItem({
    String name,
    int index,
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
        width: Adaptor.width(68),
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

  ///展示缩水条件
  Widget _buildShrinkCondition() {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(30)),
      child: Column(
        children: <Widget>[
          _buildDanShrink(),
          _buildSumShrink(),
          _buildKuaShrink(),
          _buildEvenShrink(),
          _buildPrimeShrink(),
          _buildRoadShrink(),
          _buildBigShrink(),
          _buildPattern(),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Offstage(
      offstage: model.nullFilter(),
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
                        child: LotteryView(shrink: model),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(6),
                ),
                margin: EdgeInsets.only(right: Adaptor.width(16)),
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(Adaptor.width(2)),
                ),
                child: Text(
                  '缩水计算',
                  style: TextStyle(
                    fontSize: Adaptor.sp(13),
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  model.resetFilter();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(6),
                ),
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(Adaptor.width(2)),
                ),
                child: Text(
                  '清除条件',
                  style: TextStyle(
                    fontSize: Adaptor.sp(13),
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
            fontSize: Adaptor.sp(12),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  ///胆码缩水条件
  Widget _buildDanShrink() {
    if (model.danFilter != null &&
        model.danFilter.dans != null &&
        model.danFilter.dans.length > 0) {
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
        child: Column(
          children: model.danFilter.dans.entries
              .map(
                (item) => Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: Adaptor.width(28),
                        margin: EdgeInsets.only(right: Adaptor.width(8)),
                        alignment: Alignment.center,
                        child: Text(
                          '胆码组${item.key}:',
                          style: TextStyle(
                              fontSize: Adaptor.sp(12), color: Colors.black38),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              Adaptor.width(5),
                              0,
                              Adaptor.width(5),
                              0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.only(right: Adaptor.width(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: item.value
                                        .map((ball) => _danBall(ball))
                                        .toList(),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: model.danFilter.numbers[item.key]
                                      .map(
                                        (num) => Container(
                                          height: Adaptor.width(20),
                                          width: Adaptor.width(30),
                                          margin: EdgeInsets.only(
                                              right: Adaptor.width(6)),
                                          color: Color(0xfff2f2f2),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$num',
                                            style: TextStyle(
                                              fontSize: Adaptor.sp(12),
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            model.danFilter.dans.remove(item.key);
                            model.danFilter.numbers.remove(item.key);
                          });
                        },
                        child: Container(
                          height: Adaptor.width(20),
                          width: Adaptor.width(40),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                            Adaptor.width(10),
                            0,
                            Adaptor.width(15),
                            0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent[200],
                            borderRadius:
                                BorderRadius.circular(Adaptor.width(2.0)),
                          ),
                          child: Text(
                            '删除',
                            style: TextStyle(
                                height: 0.95,
                                fontSize: Adaptor.width(12),
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
    return Container(
      child: null,
    );
  }

  ///和值缩水条件
  Widget _buildSumShrink() {
    if (model.sumFilter != null &&
        model.sumFilter.sums != null &&
        model.sumFilter.sums.length > 0) {
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
              margin: EdgeInsets.only(right: Adaptor.width(5)),
              alignment: Alignment.center,
              child: Text(
                '和值条件:',
                style: TextStyle(
                  height: 0.9,
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
                    Adaptor.width(5),
                    0,
                    Adaptor.width(5),
                    0,
                  ),
                  child: Row(
                    children: model.sumFilter.sums
                        .map(
                          (item) => Container(
                            height: Adaptor.width(20),
                            width: Adaptor.width(36),
                            margin: EdgeInsets.only(right: Adaptor.width(8)),
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
                  model.sumFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
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
    } else {
      return Container(
        child: null,
      );
    }
  }

  ///跨度缩水条件
  Widget _buildKuaShrink() {
    if (model.kuaFilter != null &&
        model.kuaFilter.kuas != null &&
        model.kuaFilter.kuas.length > 0) {
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
              margin: EdgeInsets.only(right: Adaptor.width(5)),
              alignment: Alignment.center,
              child: Text(
                '跨度条件:',
                style: TextStyle(
                  height: 0.9,
                  fontSize: Adaptor.sp(13),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      Adaptor.width(5), 0, Adaptor.width(5), 0),
                  child: Row(
                    children: model.kuaFilter.kuas
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
                  model.kuaFilter = null;
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
    } else {
      return Container(
        child: null,
      );
    }
  }

  ///奇偶缩水条件
  Widget _buildEvenShrink() {
    if (model.evenFilter != null &&
        model.evenFilter.ratios != null &&
        model.evenFilter.ratios.length > 0) {
      List<Widget> views = List();
      views.addAll(
        model.evenFilter.ratios.entries
            .map(
              (item) => Container(
                height: Adaptor.width(20),
                width: Adaptor.width(32),
                margin: EdgeInsets.only(right: Adaptor.width(8)),
                color: Color(0xfff2f2f2),
                alignment: Alignment.center,
                child: Text(
                  '${item.value}',
                  style: TextStyle(
                    fontSize: Adaptor.width(13),
                    color: Colors.black54,
                  ),
                ),
              ),
            )
            .toList(),
      );
      if (model.evenFilter.trends.length > 0) {
        views.addAll(
          model.evenFilter.trends.entries
              .map(
                (item) => Container(
                  height: Adaptor.width(20),
                  width: Adaptor.width(46),
                  margin: EdgeInsets.only(right: Adaptor.width(8)),
                  color: Color(0xfff2f2f2),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.value}',
                    style: TextStyle(
                      height: 0.90,
                      fontSize: Adaptor.sp(12),
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
              .toList(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adaptor.width(5)),
              child: Text(
                '奇偶条件:',
                style: TextStyle(
                  height: 0.90,
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
                  child: Row(
                    children: views,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  model.evenFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
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
    } else {
      return Container(
        child: null,
      );
    }
  }

  ///质合缩水条件
  Widget _buildPrimeShrink() {
    if (model.primeFilter != null &&
        model.primeFilter.ratios != null &&
        model.primeFilter.ratios.length > 0) {
      List<Widget> views = List();
      views.addAll(
        model.primeFilter.ratios.entries
            .map(
              (item) => Container(
                height: Adaptor.width(20),
                width: Adaptor.width(32),
                margin: EdgeInsets.only(right: Adaptor.width(8)),
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
      );
      if (model.primeFilter.trends.length > 0) {
        views.addAll(
          model.primeFilter.trends.entries
              .map(
                (item) => Container(
                  height: Adaptor.width(20),
                  width: Adaptor.width(46),
                  margin: EdgeInsets.only(right: Adaptor.width(8)),
                  color: Color(0xfff2f2f2),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.value}',
                    style: TextStyle(
                      height: 0.90,
                      fontSize: Adaptor.sp(12),
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
              .toList(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adaptor.width(5)),
              child: Text(
                '质合条件:',
                style: TextStyle(
                  height: 0.90,
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
                  child: Row(
                    children: views,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  model.primeFilter = null;
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
                    fontSize: Adaptor.sp(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: null,
      );
    }
  }

  ///012路缩水条件
  Widget _buildRoadShrink() {
    if (model.roadFilter != null &&
        (model.roadFilter.roads0.length > 0 ||
            model.roadFilter.roads1.length > 0 ||
            model.roadFilter.roads2.length > 0)) {
      List<Widget> views = List();
      if (model.roadFilter.roads0.length > 0) {
        views.add(
          Container(
            height: Adaptor.width(22),
            margin: EdgeInsets.only(right: Adaptor.width(10)),
            padding: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
            color: Color(0xfff2f2f2),
            child: Row(
              children: <Widget>[
                Text(
                  '0路—',
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    height: 0.95,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: model.roadFilter.roads0
                      .map(
                        (item) => Padding(
                          padding:
                              EdgeInsets.fromLTRB(0, 0, Adaptor.width(5), 0),
                          child: Text(
                            '$item',
                            style: TextStyle(
                                fontSize: Adaptor.sp(12),
                                color: Colors.black54),
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        );
      }

      if (model.roadFilter.roads1.length > 0) {
        views.add(
          Container(
            height: Adaptor.width(22),
            margin: EdgeInsets.only(right: Adaptor.width(10)),
            padding: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
            color: Color(0xfff2f2f2),
            child: Row(
              children: <Widget>[
                Text(
                  '1路—',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.sp(12),
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: model.roadFilter.roads1
                      .map(
                        (item) => Padding(
                          padding:
                              EdgeInsets.fromLTRB(0, 0, Adaptor.width(5), 0),
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
                )
              ],
            ),
          ),
        );
      }
      if (model.roadFilter.roads2.length > 0) {
        views.add(
          Container(
            height: Adaptor.width(22),
            padding: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
            color: Color(0xfff2f2f2),
            child: Row(
              children: <Widget>[
                Text(
                  '2路—',
                  style: TextStyle(
                    height: 0.95,
                    fontSize: Adaptor.sp(12),
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: model.roadFilter.roads2
                      .map(
                        (item) => Padding(
                          padding:
                              EdgeInsets.fromLTRB(0, 0, Adaptor.width(5), 0),
                          child: Text(
                            '$item',
                            style: TextStyle(
                              fontSize: Adaptor.sp(13),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adaptor.width(10)),
              child: Text(
                '012条件:',
                style: TextStyle(
                  height: 0.90,
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
                  child: Row(
                    children: views,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  model.roadFilter = null;
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
                    fontSize: Adaptor.sp(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: null,
      );
    }
  }

  ///大小缩水条件
  Widget _buildBigShrink() {
    if (model.bigFilter != null &&
        model.bigFilter.ratios != null &&
        model.bigFilter.ratios.length > 0) {
      List<Widget> views = List();
      views.addAll(
        model.bigFilter.ratios.entries
            .map(
              (item) => Container(
                height: Adaptor.width(20),
                width: Adaptor.width(32),
                margin: EdgeInsets.only(right: Adaptor.width(8)),
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
      );
      if (model.bigFilter.trends.length > 0) {
        views.addAll(
          model.bigFilter.trends.entries
              .map(
                (item) => Container(
                  height: Adaptor.width(20),
                  width: Adaptor.width(46),
                  margin: EdgeInsets.only(right: Adaptor.width(8)),
                  color: Color(0xfff2f2f2),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.value}',
                    style: TextStyle(
                      height: 0.90,
                      fontSize: Adaptor.sp(12),
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
              .toList(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adaptor.width(5)),
              child: Text(
                '大小条件:',
                style: TextStyle(
                  height: 0.90,
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
                  child: Row(
                    children: views,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  model.bigFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
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
    } else {
      return Container(
        child: null,
      );
    }
  }

  ///形态缩水条件
  Widget _buildPattern() {
    if (model.patternFilter != null &&
        (model.patternFilter.pattern.length > 0 ||
            model.patternFilter.series.length > 0)) {
      List<Widget> views = List();
      views.addAll(
        model.patternFilter.pattern.entries
            .map(
              (item) => Container(
                height: Adaptor.width(20),
                width: Adaptor.width(46),
                margin: EdgeInsets.only(right: Adaptor.width(8)),
                color: Color(0xfff2f2f2),
                alignment: Alignment.center,
                child: Text(
                  '${item.value}',
                  style: TextStyle(
                    height: 0.90,
                    fontSize: Adaptor.sp(12),
                    color: Colors.black54,
                  ),
                ),
              ),
            )
            .toList(),
      );
      if (model.patternFilter.series.length > 0) {
        views.addAll(
          model.patternFilter.series.entries
              .map(
                (item) => Container(
                  height: Adaptor.width(20),
                  width: Adaptor.width(46),
                  margin: EdgeInsets.only(right: Adaptor.width(5)),
                  color: Color(0xfff2f2f2),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.value}',
                    style: TextStyle(
                      height: 0.90,
                      fontSize: Adaptor.sp(12),
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
              .toList(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Adaptor.width(28),
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adaptor.width(5)),
              child: Text(
                '形态条件:',
                style: TextStyle(
                  height: 0.80,
                  fontSize: Adaptor.sp(12),
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.fromLTRB(Adaptor.width(5), 0, 0, 0),
                  child: Row(
                    children: views,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  model.patternFilter = null;
                });
              },
              child: Container(
                height: Adaptor.width(20),
                width: Adaptor.width(40),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                  Adaptor.width(10),
                  0,
                  Adaptor.width(15),
                  0,
                ),
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
    } else {
      return Container(
        child: null,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    model.type = type;
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
