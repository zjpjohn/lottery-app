import 'package:flutter/material.dart';

class SignClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TopLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, 0)
      ..lineTo(8, 4)
      ..lineTo(8, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class RightOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(size.width - 4, 0)
      ..arcToPoint(
        Offset(size.width, 4),
        radius: Radius.circular(4),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - 4)
      ..arcToPoint(
        Offset(size.width - 4, size.height),
        radius: Radius.circular(4),
        clockwise: false,
      )
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LeftOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(4, 0)
      ..arcToPoint(
        Offset(0, 4),
        radius: Radius.circular(4),
      )
      ..lineTo(0, size.height - 4)
      ..arcToPoint(
        Offset(4, size.height),
        radius: Radius.circular(4),
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TopOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0, 4)
      ..arcToPoint(
        Offset(4, 0),
        radius: Radius.circular(4),
        clockwise: false,
      )
      ..lineTo(size.width - 4, 0)
      ..arcToPoint(
        Offset(size.width, 4),
        radius: Radius.circular(4),
        clockwise: false,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class BottomOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0, size.height - 4)
      ..arcToPoint(
        Offset(4, size.height),
        radius: Radius.circular(4),
      )
      ..lineTo(size.width - 4, size.height)
      ..arcToPoint(
        Offset(size.width, size.height-4),
        radius: Radius.circular(4),
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
