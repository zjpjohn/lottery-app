import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/right_bottom_clipper.dart';
import 'package:lottery_app/components/adaptor.dart';

class ClipButton extends StatefulWidget {
  ///点击事件
  ///
  Function(int, int) onTap;

  ///按钮文本
  ///
  String text;

  ///按钮值
  ///
  int value;

  ///按钮宽度
  ///
  double width;

  ///按钮高度
  ///
  double height;

  ///是否选择
  ///
  int selected;

  ///是否禁用,默认：不禁用
  ///
  bool disable;

  ///按钮字体大小
  ///
  double fontSize;

  ///右侧边距
  ///
  double margin;

  ClipButton({
    Key key,
    @required this.text,
    @required this.width,
    @required this.height,
    @required this.value,
    this.selected: 0,
    this.disable: false,
    this.fontSize: 13,
    this.margin: 10,
    @required this.onTap,
  }) : super(key: key);

  @override
  ClipButtonState createState() => new ClipButtonState();
}

class ClipButtonState extends State<ClipButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: EdgeInsets.only(right: Adaptor.width(widget.margin)),
      child: GestureDetector(
        onTap: () {
          ///如果禁用,点击事件不起作用
          if (widget.disable) {
            return;
          }
          setState(() {
            widget.onTap(widget.selected, widget.value);
            if (widget.selected == 0) {
              widget.selected = 1;
            } else {
              widget.selected = 0;
            }
          });
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: widget.height,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(8),
                0,
                Adaptor.width(8),
                0,
              ),
              decoration: BoxDecoration(
                color: !widget.disable ? Color(0xfff6f6f6) : Color(0xffefefef),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '${widget.text}',
                style: TextStyle(
                    fontSize: Adaptor.sp(widget.fontSize),
                    color: !widget.disable
                        ? (widget.selected == 1
                            ? Colors.redAccent
                            : Colors.black54)
                        : Colors.black26),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Offstage(
                offstage: widget.disable || widget.selected == 0,
                child: ClipPath(
                  clipper: RightBottomCliper(),
                  child: Container(
                    height: widget.height,
                    width: widget.height,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
