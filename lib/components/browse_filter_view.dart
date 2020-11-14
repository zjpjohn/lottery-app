import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image, ImageFilter;

class BrowseFilterView extends StatefulWidget {
  ///选择动作
  Function(FilterEntry) onSelected;

  FilterEntry init;

  List<FilterEntry> data;

  List<String> dates;

  Widget child;

  BrowseFilterView({
    @required this.onSelected,
    @required this.child,
    @required this.init,
    @required this.data,
    @required this.dates,
  });

  @override
  BrowseFilterViewState createState() => new BrowseFilterViewState();
}

class BrowseFilterViewState extends State<BrowseFilterView>
    with SingleTickerProviderStateMixin {
  ///是否展开
  bool expanded = false;

  ///是否显示
  bool _hide = true;

  double _height = 0;

  FilterEntry current;

  double _opacity = 0.0;

  Animation<double> _animation;

  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffe9e9e9), width: 0.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                      _height = expanded ? 130 : 0;
                      if (expanded) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                    });
                  },
                  child: Container(
                    width: 70,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xfff8f8f8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    margin: EdgeInsets.only(left: 16, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${current.value}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              height: 0.95),
                        ),
                        Icon(
                          !expanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 17,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Color(0xffe6e6e6),
                      width: 0.4,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5, right: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          IconData(0xe641, fontFamily: 'iconfont'),
                          size: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '${widget.dates[0]}',
                        style: TextStyle(
                            color: Colors.black54, fontSize: 13, height: 1.6),
                      ),
                      Text(
                        '—',
                        style: TextStyle(
                            color: Colors.black38, fontSize: 13, height: 1.6),
                      ),
                      Text(
                        '${widget.dates[1]}',
                        style: TextStyle(
                            color: Colors.black54, fontSize: 13, height: 1.6),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                widget.child,
                Stack(
                  children: <Widget>[
                    Offstage(
                      offstage: _hide,
                      child: Opacity(
                        opacity: _opacity,
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: GestureDetector(
                            onVerticalDragStart: (drag) {
                              _height = 0;
                              expanded = false;
                              _controller.reverse();
                            },
                            child: Container(
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.linear,
                      constraints: BoxConstraints(
                        minHeight: 0,
                      ),
                      height: _height,
                      child: Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 20,
                        ),
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.start,
                          children: widget.data
                              .map(
                                (item) => GestureDetector(
                                  onTap: () {
                                    expanded = !expanded;
                                    _height = 0;
                                    _controller.reverse();
                                    if (current.key != item.key) {
                                      current = item;
                                      widget.onSelected(item);
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff5f5f5),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.value}',
                                      style: TextStyle(
                                        color: current.key == item.key
                                            ? Colors.redAccent
                                            : Colors.black54,
                                        fontSize: 14,
                                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    current = widget.init;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _opacity = _animation.value;
        });
      })
      ..addStatusListener((AnimationStatus status) {
        ///展开控制背景层展示
        if (expanded && status == AnimationStatus.forward) {
          setState(() {
            _hide = false;
          });
        } else if (status == AnimationStatus.dismissed) {
          ///收缩隐藏背景层
          setState(() {
            _hide = !_hide;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class FilterEntry {
  ///key值
  String key;

  ///value值
  String value;

  FilterEntry(this.key, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterEntry &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}
