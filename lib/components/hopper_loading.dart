import 'package:flutter/material.dart';
import 'dart:math';

class HopperLoading extends StatefulWidget {
  ///高度
  double height;

  ///动画时长
  int duration;

  ///颜色
  Color color;

  HopperLoading({
    this.height: 12,
    this.color: Colors.redAccent,
    this.duration: 2000,
  });

  @override
  HopperLoadingState createState() => new HopperLoadingState();
}

class HopperLoadingState extends State<HopperLoading>
    with SingleTickerProviderStateMixin {
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
      padding: EdgeInsets.all(10),
      child: CustomPaint(
        size: Size(2 * widget.height, 2 * widget.height),
        painter: HopperView(
            height: widget.height, color: widget.color, value: current),
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

class HopperView extends CustomPainter {
  ///漏斗颜色
  ///
  Color color;

  ///三角形高度
  ///
  double height;

  ///三角形画笔
  ///
  Paint triangle;

  ///直线画笔
  ///
  Paint line;

  ///动画当前值
  ///
  double value;

  HopperView({this.height, this.color, this.value}) {
    ///三角形画笔
    ///
    triangle = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    ///直线画笔
    ///
    line = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    ///计算减少的面积
    double deltaArea = height * height * (1 - (1 - value) * (1 - value));

    ///计算上半部分三角形
    Path trianglePath = Path()
      ..moveTo(height, height)
      ..lineTo(height * value, height * value)
      ..lineTo(height * (2 - value), height * value);

    ///计算下半部分的三角形
    double bottom = sqrt(deltaArea);
    Path bottomTriangle = Path()
      ..moveTo(height - bottom, 2 * height)
      ..lineTo(height + bottom, 2 * height)
      ..lineTo(height, 2 * height - bottom);

    canvas.save();

    ///绘制上半部分三角形
    canvas.drawPath(trianglePath, triangle);

    ///绘制连接线
    canvas.drawLine(Offset(height, height - 0.5),
        Offset(height, 2 * height - bottom + 0.5), line);

    ///绘制下半部分三角形
    canvas.drawPath(bottomTriangle, triangle);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
