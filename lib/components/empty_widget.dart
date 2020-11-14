import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class EmptyView extends StatelessWidget {
  ///空数据图标
  final String icon;

  ///图表尺寸
  final double size;

  ///空数据提示消息
  final String message;

  ///margin
  EdgeInsets margin;

  ///回调函数
  Function callback;

  EmptyView({
    @required this.icon,
    @required this.message,
    this.size = 68,
    this.margin = const EdgeInsets.only(top: 0, bottom: 0),
    @required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          callback();
        },
        child: Container(
          width: double.infinity,
          margin: margin,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: Adaptor.width(8)),
                child: Image.asset(
                  icon,
                  width: Adaptor.width(size),
                  height: Adaptor.height(size),
                ),
              ),
              Text(
                '$message',
                style: TextStyle(
                  fontSize: Adaptor.sp(12),
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
