import 'package:flutter/material.dart';

class AnimateView extends StatelessWidget {
  final Animation animation;
  final AnimationController controller;
  final Widget child;

  AnimateView({
    Key key,
    @required this.child,
    @required this.animation,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: this.child,
          ),
        );
      },
    );
  }
}
