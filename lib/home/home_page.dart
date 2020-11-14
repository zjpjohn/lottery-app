import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/concave_clipper.dart';
import 'package:lottery_app/commons/custom_tab_indicator.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/history/pl3-lottery-history.dart';
import 'package:lottery_app/home/lottery/lotteries.dart';
import 'package:lottery_app/home/lottery/fc3d_lottery.dart';
import 'package:lottery_app/home/lottery/pl3_lottery.dart';
import 'package:lottery_app/home/lottery/ssq_lottery.dart';
import 'package:lottery_app/home/lottery/dlt_lottery.dart';
import 'package:lottery_app/home/lottery/qlc_lottery.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_tabs.dart' as custom_tabs;
import 'package:lottery_app/commons/custom_text.dart';
import 'package:lottery_app/model/dlt_lottery.dart';
import 'package:lottery_app/model/fc3d_lottery.dart';
import 'package:lottery_app/model/lotteries.dart';
import 'package:lottery_app/model/pl3_lottery.dart';
import 'package:lottery_app/model/qlc_lottery.dart';
import 'package:lottery_app/model/ssq_lottery.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  @override
  IndexPageState createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _tabs = <Widget>[
    CustomText(
      text: '开奖',
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

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    //获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LotteriesModel()),
          ChangeNotifierProvider(create: (_) => Fc3dLotteryModel()),
          ChangeNotifierProvider(create: (_) => Pl3LotteryModel()),
          ChangeNotifierProvider(create: (_) => SsqLotteryModel()),
          ChangeNotifierProvider(create: (_) => DltLotteryModel()),
          ChangeNotifierProvider(create: (_) => QlcLotteryModel()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              ClipPath(
                clipper: ConcaveClipper(),
                child: Container(
                  alignment: Alignment.topCenter,
                  height: Adaptor.height(250),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFE8D01),
                        const Color(0xFFFf4600),
                      ],
                    ),
                  ),
                  child: null,
                ),
              ),
              Consumer6(builder: (BuildContext context,
                  LotteriesModel lotteries,
                  Fc3dLotteryModel fc3d,
                  Pl3LotteryModel pl3,
                  SsqLotteryModel ssq,
                  DltLotteryModel dlt,
                  QlcLotteryModel qlc,
                  Widget child) {
                List<Widget> _views = <Widget>[
                  LotteriesPage(lotteries),
                  Fc3dLotteryPage(fc3d),
                  Pl3LotteryPage(pl3),
                  SsqLotteryPage(ssq),
                  DltLotteryPage(dlt),
                  QlcLotteryPage(qlc)
                ];
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: statusBarHeight,
                        left: Adaptor.width(16),
                        right: Adaptor.width(16),
                      ),
                      margin: EdgeInsets.only(bottom: Adaptor.width(8)),
                      width: double.infinity,
                      child: PreferredSize(
                        preferredSize:
                            Size.fromHeight(Adaptor.height(Constant.barHeight)),
                        child: custom_tabs.CTabBar(
                          controller: _tabController,
                          tabs: _tabs,
                          isScrollable: true,
                          labelColor: Colors.white,
                          labelPadding: EdgeInsets.zero,
                          labelStyle: TextStyle(
                            fontSize: Adaptor.sp(20),
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: Adaptor.sp(16),
                            fontWeight: FontWeight.w400,
                          ),
                          indicator: CUnderlineTabIndicator(
                            wWidth: Adaptor.width(10),
                            borderSide: BorderSide(
                              width: Adaptor.width(2.8),
                              color: Colors.white,
                            ),
                          ),
                          indicatorWeight: Adaptor.width(6),
                          unselectedLabelColor: Color(0xffFFD6A5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: custom_tabs.TabBarView(
                        controller: _tabController,
                        children: _views,
                      ),
                    )
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: ScrollableState(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
