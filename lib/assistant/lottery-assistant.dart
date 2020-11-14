import 'package:flutter/material.dart';
import 'package:lottery_app/commons/mappbar.dart';

class LotteryAssistantPage extends StatefulWidget {
  @override
  LotteryAssistantPageState createState() => new LotteryAssistantPageState();
}

class LotteryAssistantPageState extends State<LotteryAssistantPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          MAppBar('彩票助手'),
        ],
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
