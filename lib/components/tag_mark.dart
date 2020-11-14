import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class MarkView extends StatelessWidget {
  String name;

  MarkView({this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: Adaptor.width(8)),
      padding: EdgeInsets.symmetric(
          horizontal: Adaptor.width(6), vertical: Adaptor.width(1)),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2.0),
        color: Color(0xFFFF512F).withOpacity(0.2),
      ),
      child: Text(
        '$name',
        style: TextStyle(color: Colors.redAccent, fontSize: Adaptor.sp(10)),
      ),
    );
  }
}
