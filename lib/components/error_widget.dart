import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final Color color;
  final Function callback;

  ErrorView(
      {this.color = Colors.black26,
      @required this.message,
      @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/error.png',
                fit: BoxFit.contain,
                width: Adaptor.width(100),
                height: Adaptor.height(66),
              ),
              Text(
                '$message',
                style: TextStyle(fontSize: Adaptor.sp(13), color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
