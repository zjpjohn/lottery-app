import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/mappbar.dart';

class Fc3dTrendPage extends StatefulWidget {
  @override
  Fc3dTrendPageState createState() => new Fc3dTrendPageState();
}

class Fc3dTrendPageState extends State<Fc3dTrendPage> {
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
