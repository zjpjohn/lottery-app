import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/mappbar.dart';

class DltTrendPage extends StatefulWidget {
  @override
  DltTrendPageState createState() => new DltTrendPageState();
}

class DltTrendPageState extends State<DltTrendPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            MAppBar('基本走势'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
