import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/custom_tab_indicator.dart';
import 'package:lottery_app/forecast/items/picker_forecast.dart';
import 'package:lottery_app/forecast/items/fc3d_forecast.dart';
import 'package:lottery_app/forecast/items/pl3_forecast.dart';
import 'package:lottery_app/forecast/items/ssq_forecast.dart';
import 'package:lottery_app/forecast/items/dlt_forecast.dart';
import 'package:lottery_app/forecast/items/qlc_forecast.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_tabs.dart' as custom_tabs;
import 'package:lottery_app/commons/custom_text.dart';
import 'package:lottery_app/components/adaptor.dart';

class ForecastPage extends StatefulWidget {
  @override
  ForecastPageState createState() => new ForecastPageState();
}

class ForecastPageState extends State<ForecastPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _tabs = <Widget>[
    CustomText(
      text: '精选',
      width: Adaptor.width(48),
      height: Adaptor.height(36),
      alignment: TextAlignment.bottom,
    ),
    CustomText(
      text: '福彩三',
      width: Adaptor.width(64),
      height: Adaptor.height(36),
      alignment: TextAlignment.bottom,
    ),
    CustomText(
      text: '排列三',
      width: Adaptor.width(64),
      height: Adaptor.height(36),
      alignment: TextAlignment.bottom,
    ),
    CustomText(
      text: '双色球',
      width: Adaptor.width(64),
      height: Adaptor.height(36),
      alignment: TextAlignment.bottom,
    ),
    CustomText(
      text: '大乐透',
      width: Adaptor.width(64),
      height: Adaptor.height(36),
      alignment: TextAlignment.bottom,
    ),
    CustomText(
      text: '七乐彩',
      width: Adaptor.width(64),
      height: Adaptor.height(36),
      alignment: TextAlignment.bottom,
    ),
  ];

  List<Widget> _views = <Widget>[
    PickerForecastPage(),
    Fc3dForecastPage(),
    Pl3ForecastPage(),
    SsqForecastPage(),
    DltForecastPage(),
    QlcForecastPage()
  ];

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    //获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          color: Color(0xF8F8F8),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: statusBarHeight,
                  left: Adaptor.width(16),
                  right: Adaptor.width(16),
                ),
                width: double.infinity,
                margin: EdgeInsets.only(bottom: Adaptor.width(8)),
                child: PreferredSize(
                  preferredSize:
                      Size.fromHeight(Adaptor.height(Constant.barHeight)),
                  child: custom_tabs.CTabBar(
                    controller: _tabController,
                    tabs: _tabs,
                    isScrollable: true,
                    labelPadding: EdgeInsets.zero,
                    labelColor: Colors.black,
                    labelStyle: TextStyle(
                      fontSize: Adaptor.sp(20),
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: TextStyle(
                        fontSize: Adaptor.sp(16), fontWeight: FontWeight.w400),
                    indicator: CUnderlineTabIndicator(
                      wWidth: Adaptor.width(10),
                      borderSide: BorderSide(
                        width: Adaptor.width(2.8),
                        color: Color(0xffFF4600),
                      ),
                    ),
                    indicatorWeight: Adaptor.height(6),
                    unselectedLabelColor: Color(0x9F000000),
                  ),
                ),
              ),
              Expanded(
                child: custom_tabs.TabBarView(
                    controller: _tabController, children: _views),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _tabs.length, vsync: ScrollableState());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
