import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class VipPrivilege extends StatelessWidget {
  String name;

  int icon;

  List<Color> colors;

  Function callback;

  VipPrivilege(
      {@required this.name,
      @required this.icon,
      @required this.colors,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: Column(
        children: <Widget>[
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ).createShader(Offset.zero & bounds.size);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: Adaptor.width(2)),
              child: Icon(
                IconData(
                  icon,
                  fontFamily: 'iconfont',
                ),
                size: Adaptor.sp(40),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adaptor.width(4)),
            child: Text(
              name,
              style:
                  TextStyle(color: Color(0xff666466), fontSize: Adaptor.sp(12)),
            ),
          )
        ],
      ),
    );
  }
}
