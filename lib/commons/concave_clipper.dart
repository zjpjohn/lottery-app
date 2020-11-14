import 'package:flutter/material.dart';

class ConcaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 48);

    var firstControlPoint = new Offset(size.width / 2, size.height);
    var firstPoint = new Offset(size.width, size.height - 48);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstPoint.dx,
      firstPoint.dy,
    );
    path.lineTo(size.width, size.height - 48);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TopCurveClipper extends CustomClipper<Path> {
  final double height;

  TopCurveClipper({this.height = 8});

  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, 0.0);

    var firstControlPoint = new Offset(size.width / 2, height);
    var firstPoint = new Offset(size.width, 0.0);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstPoint.dx,
      firstPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
