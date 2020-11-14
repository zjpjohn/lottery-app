import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/mappbar.dart';

class Pl3TrendPage extends StatefulWidget {
  @override
  Pl3TrendPageState createState() => new Pl3TrendPageState();
}

class Pl3TrendPageState extends State<Pl3TrendPage> {
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
