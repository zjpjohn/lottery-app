import 'package:flutter/material.dart';

class RightBottomCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - size.height / 2, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
