import 'package:flutter/material.dart';

class CCard extends StatelessWidget {
  const CCard({
    Key key,
    this.color: Colors.white,
    this.shadowColor: const Color(0x1fcFcFcF),
    this.borderRadius: 3.0,
    this.blurRadius: 8.0,
    this.offset: const Offset(0.0, 3.0),
    @required this.child,
  }) : super(key: key);

  final Widget child;

  final Color color;

  final Color shadowColor;

  final double borderRadius;

  final double blurRadius;

  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: child,
    );
  }
}
