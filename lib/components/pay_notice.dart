import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class PayNoticeView extends StatelessWidget {
  Color color;
  String message;
  Function onTap;

  PayNoticeView({
    this.color = Colors.black38,
    this.message = '余额不足,点此充值',
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap();
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: Adaptor.width(8)),
                child: Image.asset(
                  'assets/images/charge.png',
                  width: Adaptor.width(100),
                  height: Adaptor.width(100),
                ),
              ),
              Text(
                '$message',
                style: TextStyle(
                  fontSize: Adaptor.sp(13),
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
