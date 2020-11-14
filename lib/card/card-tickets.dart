import 'package:flutter/material.dart';
import 'package:lottery_app/commons/mappbar.dart';

class CardTicketPage extends StatefulWidget {
  @override
  CardTicketPageState createState() => new CardTicketPageState();
}

class CardTicketPageState extends State<CardTicketPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          MAppBar('我的卡券'),
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
