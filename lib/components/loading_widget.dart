import 'dart:core';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  ///动画持续时长
  ///
  int duration;

  ///小球1的初始半径
  ///
  double radiusL;

  ///小球2的初始半径
  ///
  double radiusR;

  ///最大半径
  double maxRadius;

  ///最小半径
  double minRadius;

  ///初始化两球之间的距离
  ///
  double gap;

  ///小球1的颜色
  Color colorL;

  ///小球2的颜色
  Color colorR;

  ///交叉的颜色
  Color mixColor;

  Loading({
    this.duration: 1000,
    this.radiusL: 5,
    this.radiusR: 5,
    this.maxRadius: 6,
    this.minRadius: 3.0,
    this.gap: 10,
    this.colorL: const Color(0xFFFFCA18),
    this.colorR: const Color(0xFFF2544C),
    this.mixColor: Colors.black12,
  });

  @override
  LoadingState createState() => new LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  ///动画控制器
  ///
  AnimationController controller;

  ///动画值
  ///
  Animation<double> animation;

  ///当前值
  double current = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 32,
      alignment: Alignment.center,
      child: CustomPaint(
        painter: LoadingView(
          radiusL: widget.radiusL,
          radiusR: widget.radiusR,
          current: current,
          colorL: widget.colorL,
          colorR: widget.colorR,
          maxRadius: widget.maxRadius,
          minRadius: widget.minRadius,
          mixColor: widget.mixColor,
          distance: widget.radiusL + widget.gap + widget.radiusR,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          current = controller.value;
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class LoadingView extends CustomPainter {
  ///左球颜色
  Color colorL;

  ///右球颜色
  Color colorR;

  ///交叉部分的颜色
  Color mixColor;

  ///左球半径
  double radiusL;

  ///右球半径
  double radiusR;

  ///最大半径
  double maxRadius;

  ///最小半径
  double minRadius;

  ///当前动画值
  ///
  double current;

  ///两球球心距离
  double distance;

  ///绘制左球
  Paint paintL;

  ///绘制右球
  Paint paintR;

  ///绘制交叉部分
  Paint paintMix;

  LoadingView({
    @required this.radiusL,
    @required this.radiusR,
    @required this.current,
    @required this.colorL,
    @required this.colorR,
    @required this.maxRadius,
    @required this.minRadius,
    @required this.mixColor,
    @required this.distance,
  }) {
    paintL = Paint()
      ..color = colorL
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    paintR = Paint()
      ..color = colorR
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    paintMix = Paint()
      ..color = mixColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double centerY = size.height / 2;
    double startX = size.width / 2 - distance / 2;
    double endX = size.width / 2 + distance / 2;

    double ltrX, rtlX, dist, ltrRadius, rtlRadius;

    if (current <= 0.25) {
      ltrX = startX + current * distance / 0.5;
      rtlX = endX - current * distance / 0.5;
      ltrRadius = radiusL + (maxRadius - radiusL) * current / 0.25;
      rtlRadius = radiusR - (radiusR - minRadius) * current / 0.25;
    } else if (current <= 0.5) {
      ltrX = startX + current * distance / 0.5;
      rtlX = endX - current * distance / 0.5;
      ltrRadius = maxRadius - (maxRadius - radiusL) * (current - 0.25) / 0.25;
      rtlRadius = minRadius + (radiusR - minRadius) * (current - 0.25) / 0.25;
    } else if (current <= 0.75) {
      ltrX = endX - (current - 0.5) * distance / 0.5;
      rtlX = startX + (current - 0.5) * distance / 0.5;
      ltrRadius = radiusL - (radiusL - minRadius) * (current - 0.5) / 0.25;
      rtlRadius = radiusR + (maxRadius - radiusR) * (current - 0.5) / 0.25;
    } else {
      ltrX = endX - (current - 0.5) * distance / 0.5;
      rtlX = startX + (current - 0.5) * distance / 0.5;
      ltrRadius = minRadius + (radiusL - minRadius) * (current - 0.75) / 0.25;
      rtlRadius = maxRadius - (maxRadius - radiusR) * (current - 0.75) / 0.25;
    }

    dist = (ltrX - rtlX).abs();
    canvas.save();

    ///左侧圆
    Rect circleL =
        Rect.fromCircle(center: Offset(ltrX, centerY), radius: ltrRadius);
    Path lPath = Path()..addOval(circleL);

    ///右侧圆
    Rect circleR =
        Rect.fromCircle(center: Offset(rtlX, centerY), radius: rtlRadius);
    Path rPath = Path()..addOval(circleR);

    ///绘制左侧的圆
    canvas.drawCircle(Offset(ltrX, centerY), ltrRadius, paintL);

    ///绘制右侧圆
    canvas.drawCircle(Offset(rtlX, centerY), rtlRadius, paintR);
    if (dist < ltrRadius + rtlRadius) {
      ///左右圆的交集
      Path intersect = Path.combine(PathOperation.intersect, lPath, rPath);

      ///绘制交叉部分
      canvas.drawPath(intersect, paintMix);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
