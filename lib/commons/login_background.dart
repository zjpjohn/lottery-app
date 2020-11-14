import 'package:flutter/material.dart';
import 'package:lottery_app/commons/concave_clipper.dart';
import 'package:lottery_app/commons/constants.dart';
class LoginBackground extends StatelessWidget {
  String _title;

  LoginBackground(this._title);

  Widget topHalf(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var deviceSize = MediaQuery.of(context).size;
    return new Container(
        height: deviceSize.height * 0.5,
        child: ClipPath(
          clipper: ConcaveClipper(),
          child: Stack(
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                  colors: [
                    const Color(0xFFFE8C00),
                    const Color(0xFFF83600),
                  ],
                )),
              ),
              Container(
                padding: EdgeInsets.only(top: statusBarHeight),
                height: Constant.barHeight + statusBarHeight,
                width: double.infinity,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: new Container(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            IconData(Constant.backIcon, fontFamily: 'iconfont'),
                            size: 16,
                            color: Colors.white70,
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
                              '$_title',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context)],
    );
  }
}
