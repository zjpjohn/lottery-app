import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/clip_button.dart';

class SegShrinkWidget extends StatefulWidget {
  Function(SegmentShrink) onSelected;

  SegShrinkWidget({@required this.onSelected});

  @override
  SegShrinkWidgetState createState() => new SegShrinkWidgetState();
}

Set<int> segment31 = Set.of([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
Set<int> segment32 = Set.of([12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
Set<int> segment33 = Set.of([23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]);

Set<int> segment41 = Set.of([1, 2, 3, 4, 5, 6, 7, 8]);
Set<int> segment42 = Set.of([9, 10, 11, 12, 13, 14, 15, 16]);
Set<int> segment43 = Set.of([17, 18, 19, 20, 21, 22, 23, 24]);
Set<int> segment44 = Set.of([25, 26, 27, 28, 29, 30, 31, 32, 33]);

class SegmentShrink {
  ///3分区选择的数据
  ///
  Map<int, Set<int>> seg3 = {
    1: Set(),
    2: Set(),
    3: Set(),
  };

  ///4分区选择的数据
  ///
  Map<int, Set<int>> seg4 = {
    1: Set(),
    2: Set(),
    3: Set(),
    4: Set(),
  };

  ///分区出号过滤
  bool filter(List<int> balls) {
    Set<int> ball = Set.of(balls);
    if (seg3[1].length > 0) {
      if (!seg3[1].contains(segment31.intersection(ball).length)) {
        return false;
      }
    }
    if (seg3[2].length > 0) {
      if (!seg3[2].contains(segment32.intersection(ball).length)) {
        return false;
      }
    }
    if (seg3[3].length > 0) {
      if (!seg3[3].contains(segment33.intersection(ball).length)) {
        return false;
      }
    }
    if (seg4[1].length > 0) {
      if (!seg4[1].contains(segment41.intersection(ball).length)) {
        return false;
      }
    }
    if (seg4[2].length > 0) {
      if (!seg4[2].contains(segment42.intersection(ball).length)) {
        return false;
      }
    }
    if (seg4[3].length > 0) {
      if (!seg4[3].contains(segment43.intersection(ball).length)) {
        return false;
      }
    }
    if (seg4[4].length > 0) {
      if (!seg4[4].contains(segment44.intersection(ball).length)) {
        return false;
      }
    }
    return true;
  }
}

class SegShrinkWidgetState extends State<SegShrinkWidget> {
  ///显示的分区标识
  ///
  int current = 1;

  ///已选择的数据
  ///
  SegmentShrink model = SegmentShrink();

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
                    "分区出号",
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
                      if (model.seg3[1].length > 0 ||
                          model.seg3[2].length > 0 ||
                          model.seg3[3].length > 0 ||
                          model.seg4[1].length > 0 ||
                          model.seg4[2].length > 0 ||
                          model.seg4[3].length > 0 ||
                          model.seg4[4].length > 0) {
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
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildSegTypes(),
                  _buildSegmentContainer(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSegTypes() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        Adaptor.width(20),
        0,
        Adaptor.width(10),
      ),
      child: Row(
        children: <Widget>[
          ClipButton(
            text: '三分区',
            value: 1,
            width: Adaptor.width(66),
            height: Adaptor.width(28),
            margin: 15,
            selected: current == 1 ? 1 : 0,
            onTap: (selected, value) {
              setState(() {
                if (current != 1) {
                  setState(() {
                    current = 1;
                  });
                }
              });
            },
          ),
          ClipButton(
            text: '四分区',
            value: 2,
            width: Adaptor.width(66),
            height: Adaptor.width(28),
            margin: 15,
            selected: current == 2 ? 1 : 0,
            onTap: (selected, value) {
              setState(() {
                if (current != 2) {
                  setState(() {
                    current = 2;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentContainer() {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: current == 2,
          child: _buildSeg3Container(),
        ),
        Offstage(
          offstage: current == 1,
          child: _buildSeg4Container(),
        ),
      ],
    );
  }

  Widget _buildSeg3Container() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(10),
        0,
        Adaptor.width(10),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(15)),
            child: _buildSegmentItem(
                group: 1, index: 1, title: '一区个数', remark: '一区号码01~11'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(15)),
            child: _buildSegmentItem(
                group: 1, index: 2, title: '二区个数', remark: '二区号码12~22'),
          ),
          _buildSegmentItem(
              group: 1, index: 3, title: '三区个数', remark: '三区号码23~33'),
        ],
      ),
    );
  }

  Widget _buildSeg4Container() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(10),
        Adaptor.width(10),
        0,
        Adaptor.width(10),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(15)),
            child: _buildSegmentItem(
                group: 2, index: 1, title: '一区个数', remark: '一区号码01~08'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(15)),
            child: _buildSegmentItem(
                group: 2, index: 2, title: '二区个数', remark: '二区号码09~16'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Adaptor.width(15)),
            child: _buildSegmentItem(
                group: 2, index: 3, title: '三区个数', remark: '三区号码17~24'),
          ),
          _buildSegmentItem(
              group: 2, index: 4, title: '四区个数', remark: '四区号码25~33'),
        ],
      ),
    );
  }

  Widget _buildSegmentItem({
    int group,
    int index,
    String title,
    String remark,
  }) {
    switch (group) {
      case 1:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: Adaptor.width(20),
              padding: EdgeInsets.only(right: Adaptor.width(8)),
              alignment: Alignment.center,
              child: Text(
                '$title',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Adaptor.width(12),
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                runSpacing: Adaptor.width(12),
                children: <Widget>[
                  ClipButton(
                    text: '0',
                    value: 0,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(0) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '1',
                    value: 1,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(1) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '2',
                    value: 2,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(2) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '3',
                    value: 3,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(3) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '4',
                    value: 4,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(4) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '5',
                    value: 5,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(5) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '6',
                    value: 6,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg3[index].contains(6) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg3[index].add(value);
                        } else {
                          model.seg3[index].remove(value);
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: Adaptor.width(24),
                    child: Text(
                      '($remark)',
                      style: TextStyle(
                        fontSize: Adaptor.sp(13),
                        color: Colors.black54,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: Adaptor.width(20),
              padding: EdgeInsets.only(
                right: Adaptor.width(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '$title',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Adaptor.sp(12),
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                runSpacing: Adaptor.width(12),
                children: <Widget>[
                  ClipButton(
                    text: '0',
                    value: 0,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(0) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '1',
                    value: 1,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(1) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '2',
                    value: 2,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(2) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '3',
                    value: 3,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(3) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '4',
                    value: 4,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(4) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '5',
                    value: 5,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(5) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  ClipButton(
                    text: '6',
                    value: 6,
                    width: Adaptor.width(44),
                    height: Adaptor.width(24),
                    selected: model.seg4[index].contains(6) ? 1 : 0,
                    onTap: (selected, value) {
                      setState(() {
                        if (selected == 0) {
                          model.seg4[index].add(value);
                        } else {
                          model.seg4[index].remove(value);
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: Adaptor.width(24),
                    child: Text(
                      '($remark)',
                      style: TextStyle(
                        fontSize: Adaptor.sp(13),
                        color: Colors.black54,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
    }
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
