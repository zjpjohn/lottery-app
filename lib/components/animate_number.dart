import 'package:flutter/material.dart';

class AnimateNumber extends StatefulWidget {
  ///数字值
  int number;

  ///初始数字值
  int start;

  ///持续时间
  int duration;

  TextStyle style;

  AnimateNumber({
    @required this.number,
    this.start: 0,
    this.duration: 1000,
    @required this.style,
  });

  @override
  AnimateNumberState createState() => new AnimateNumberState();
}

class AnimateNumberState extends State<AnimateNumber>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Text(
            '${(widget.start + animation.value * (widget.number - widget.start)).toInt()}',
            style: widget.style,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
