import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashShapeBorder extends ShapeBorder {
  final Color color;
  final double dashWidth;
  final double width;

  DashShapeBorder(
      {this.width = 1.0, this.dashWidth = 4.0, this.color = Colors.white});

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var width = rect.width, height = rect.height;
    var path = Path();
    path.addRect(rect);

    ///左边的缺口
    path.addArc(
        Rect.fromCenter(
            center: Offset(0, height / 2), width: height, height: height),
        -pi / 2,
        pi);

    ///右边缺口
    path.addArc(
        Rect.fromCenter(
            center: Offset(width, height / 2), width: height, height: height),
        pi / 2,
        pi);
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final dashCount = ((rect.width - rect.height) / (2 * dashWidth)).floor();
    Offset start = Offset(rect.height / 2 + dashWidth, rect.height / 2);
    for (int i = 0; i < dashCount; i++) {
      var offset = start + Offset(i * 2 * dashWidth, 0);
      canvas.drawLine(offset, offset + Offset(dashWidth, 0), paint);
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {}

  @override
  EdgeInsetsGeometry get dimensions {}
}

class HoleShapeBorder extends ShapeBorder {
  final Offset offset;
  final double size;

  HoleShapeBorder({this.offset = const Offset(0.03, 0.1), this.size = 16});

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(5)));
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(6)));
    var w = rect.width;
    var h = rect.height;
    var d = size;

    ///左侧打洞
    var offsetXY = Offset(
        rect.topLeft.dx + offset.dx * w, rect.topLeft.dy + offset.dy * h);
    _getHold(path, 1, d, offsetXY);

    ///右侧打洞
    var rightOffset = Offset(
        rect.topRight.dx - offset.dx * w-size, rect.topRight.dy + offset.dy * h);
    _getHold(path, 1, d, rightOffset);
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  _getHold(Path path, int count, double d, Offset offset) {
    var left = offset.dx;
    var top = offset.dy;
    var right = left + d;
    var bottom = top + d;
    path.addOval(Rect.fromLTRB(left, top, right, bottom));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return null;
  }
}

class CouponDashCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: DashShapeBorder(color: Colors.black38),
      child: Container(
        height: 18,
        child: null,
      ),
    );
  }
}
