import 'package:flutter/material.dart';

class FadeAnimateView extends StatelessWidget {
  final Animation animation;

  final AnimationController controller;

  final Widget child;

  FadeAnimateView({
    Key key,
    @required this.animation,
    @required this.controller,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: this.child,
          );
        });
  }
}
