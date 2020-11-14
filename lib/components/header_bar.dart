import 'package:flutter/material.dart';
import 'package:lottery_app/components/adaptor.dart';

class HeaderBar extends StatelessWidget {
  String title;

  int icon;

  double iconSize;

  double fontSize;

  double height;

  Color color;

  EdgeInsets padding;

  HeaderBar({
    this.title,
    this.icon,
    this.iconSize = 14,
    this.fontSize = 14,
    this.height = 32,
    this.color = Colors.black54,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adaptor.height(height),
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: Adaptor.width(6)),
                    child: Icon(
                      IconData(icon, fontFamily: 'iconfont'),
                      size: Adaptor.sp(iconSize),
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.sp(fontSize),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
