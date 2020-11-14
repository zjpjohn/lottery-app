import 'package:flutter/material.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/lottery_news_widget.dart';
import 'package:lottery_app/components/random_master.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/vip_navigator.dart';

class PickerForecastPage extends StatefulWidget {
  @override
  PickerForecastPageState createState() => new PickerForecastPageState();
}

class PickerForecastPageState extends State<PickerForecastPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, String> randoms = {
    'fc3d': '福彩3D',
    'pl3': '排列三',
    'ssq': '双色球',
    'dlt': '大乐透',
    'qlc': '七乐彩'
  };

  ///类型
  ///
  String type = 'fc3d';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        physics: EasyRefreshPhysics(topBouncing: false),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(
                Adaptor.width(14),
                Adaptor.width(15),
                Adaptor.width(14),
                Adaptor.width(8),
              ),
              child: RandomMasterWidget(
                type: type,
                title: randoms[type],
                callback: (value) {
                  if (type == value) {
                    return;
                  }
                  setState(() {
                    type = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: Adaptor.width(8),
                bottom: Adaptor.width(16),
              ),
              child: VipNavigator(),
            ),
            LotteryNewsView(),
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
