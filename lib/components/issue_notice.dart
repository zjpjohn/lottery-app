import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class IssueNotice extends StatelessWidget {
  String notice;

  double height;

  IssueNotice({
    this.notice,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adaptor.height(height),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: Adaptor.width(16),
        right: Adaptor.width(16),
      ),
      decoration: BoxDecoration(color: Color(0xFFF8F8F8)),
      child: Text(
        notice,
        style: TextStyle(
          color: Colors.redAccent.withOpacity(0.75),
          fontSize: Adaptor.sp(13),
        ),
      ),
    );
  }
}
