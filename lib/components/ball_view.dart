import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

enum BallType { red, blue }

class BallView extends StatelessWidget {
  String ball;

  BallType type;

  BallView({this.ball, this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptor.width(26),
      height: Adaptor.height(26),
      margin: EdgeInsets.only(right: Adaptor.width(8)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: type == BallType.red ? Color(0xFFFE5139) : Color(0xFF0081FF),
      ),
      child: Text(
        ball,
        style: TextStyle(
          color: Colors.white,
          fontSize: Adaptor.sp(14),
        ),
      ),
    );
  }
}
