import 'package:flutter/material.dart';
import 'dart:io';

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return new GlowingOverscrollIndicator(
        showLeading: false,
        showTrailing: false,
        child: child,
        axisDirection: axisDirection,
        color: Colors.transparent,
      );
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
