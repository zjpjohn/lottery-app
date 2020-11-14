import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';

class NavAppBar extends StatelessWidget {
  final String title;

  final Widget left;

  final Widget right;

  final Color color;

  final Color fontColor;

  NavAppBar({
    this.title = '',
    this.left,
    this.right,
    this.color = Colors.white,
    this.fontColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    //获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: Adaptor.width(20),
        right: Adaptor.width(20),
      ),
      width: double.infinity,
      color: color,
      child: PreferredSize(
        preferredSize: Size.fromHeight(Adaptor.height(Constant.barHeight)),
        child: Container(
          height: Adaptor.height(Constant.barHeight),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: left != null
                    ? InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: left,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerLeft,
                        child: null,
                      ),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$title',
                        style: TextStyle(
                            fontSize: Adaptor.sp(18), color: fontColor),
                      ),
                    ]),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: right,
                ),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MAppBar extends StatelessWidget {
  final String title;

  MAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    //获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          const Color(0xFFFE8C00),
          const Color(0xFFF83600),
        ]),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(Adaptor.height(Constant.barHeight)),
        child: Container(
          height: Adaptor.height(Constant.barHeight),
          child: Row(
            children: <Widget>[
              Expanded(
                child: new InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Container(
                    height: Adaptor.height(32),
                    width: Adaptor.width(32),
                    padding: EdgeInsets.only(left: Adaptor.width(20)),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      IconData(Constant.backIcon, fontFamily: 'iconfont'),
                      size: Adaptor.sp(16),
                      color: Colors.white,
                    ),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$title',
                        style: TextStyle(
                            fontSize: Adaptor.sp(18), color: Colors.white),
                      ),
                    ]),
                flex: 2,
              ),
              Expanded(
                child: Text(''),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
