import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class SignCard extends StatelessWidget {
  ///卡片标题
  String title;

  ///是否已经签到
  bool hasSigned;

  //当前标识
  int index;

  //连续门槛
  int throttle;

  SignCard({
    @required this.title,
    @required this.hasSigned,
    @required this.index,
    @required this.throttle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptor.width(38),
      height: Adaptor.height(48),
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(4),
        Adaptor.width(2),
        Adaptor.width(4),
        Adaptor.width(6),
      ),
      decoration: BoxDecoration(
        color: hasSigned ? Color(0xffFD553A) : Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(Adaptor.width(3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(
              color: hasSigned ? Colors.white : Colors.black38,
              fontSize: Adaptor.sp(13),
            ),
          ),
          _getMarkInfo(),
        ],
      ),
    );
  }

  Widget _getMarkInfo() {
    if (hasSigned) {
      return Icon(
        IconData(0xe8bf, fontFamily: 'iconfont'),
        color: index == throttle ? Color(0xFFFFC90E) : Colors.white,
        size: Adaptor.sp(18),
      );
    }
    return Icon(
      IconData(0xe8bf, fontFamily: 'iconfont'),
      color: index == throttle ? Color(0xffFD553A) : Colors.black12,
      size: Adaptor.sp(18),
    );
  }
}
