import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/animate_view.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/components/custom_scroll_behavior.dart';
import 'package:lottery_app/components/vip_navigator.dart';
import 'package:lottery_app/shrink/fc3d_shrink.dart';
import 'package:lottery_app/shrink/pl3_shrink.dart';
import 'package:lottery_app/shrink/qlc_shrink.dart';
import 'package:lottery_app/shrink/ssq_shrink.dart';
import 'package:lottery_app/shrink/dlt_shrink.dart';
import 'package:lottery_app/table/fc3d-table.dart';
import 'package:lottery_app/table/pl3-table.dart';
import 'package:lottery_app/trend/dlt_trend.dart';
import 'package:lottery_app/trend/fc3d_trend.dart';
import 'package:lottery_app/trend/pl3_trend.dart';
import 'package:lottery_app/trend/qlc_trend.dart';
import 'package:lottery_app/trend/ssq_trend.dart';
import 'package:lottery_app/components/adaptor.dart';

class LotteryMeansPage extends StatefulWidget {
  @override
  LotteryMeansPageState createState() => new LotteryMeansPageState();
}

class LotteryMeansPageState extends State<LotteryMeansPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String current;

  AnimationController controller;

  ScrollController scrollController = ScrollController();

  final List<MeansInfo> means = [
    MeansInfo(name: '福彩3D', image: 'assets/images/fc3d.png', items: [
      MeansItem(
        name: '缩水计算',
        type: 'f_shrink',
        page: Fc3dShrinkPage(),
      ),
      MeansItem(
        name: '基本走势',
        type: 'f_trend',
        done: false,
        page: Fc3dTrendPage(),
      ),
      MeansItem(
        name: '快速查表',
        type: 'f_table',
        page: Fc3dTablePage(),
      ),
    ]),
    MeansInfo(name: '排列三', image: 'assets/images/pl3.png', items: [
      MeansItem(
        name: '缩水计算',
        type: 'p_shrink',
        page: Pl3ShrinkPage(),
      ),
      MeansItem(
        name: '基本走势',
        type: 'p_trend',
        done: false,
        page: Pl3TrendPage(),
      ),
      MeansItem(
        name: '快速查表',
        type: 'p_table',
        page: Pl3TablePage(),
      ),
    ]),
    MeansInfo(name: '双色球', image: 'assets/images/ssq.png', items: [
      MeansItem(
        name: '缩水计算',
        type: 's_shrink',
        page: SsqShrinkPage(),
      ),
      MeansItem(
        name: '基本走势',
        type: 's_trend',
        done: false,
        page: SsqTrendPage(),
      ),
    ]),
    MeansInfo(name: '大乐透', image: 'assets/images/dlt.png', items: [
      MeansItem(
        name: '缩水计算',
        type: 'd_shrink',
        page: DltShrinkPage(),
      ),
      MeansItem(
        name: '基本走势',
        type: 'd_trend',
        done: false,
        page: DltTrendPage(),
      ),
    ]),
    MeansInfo(name: '七乐彩', image: 'assets/images/qlc.png', items: [
      MeansItem(
        name: '缩水计算',
        type: 'q_shrink',
        page: QlcShrinkPage(),
      ),
      MeansItem(
        name: '基本走势',
        type: 'q_trend',
        done: false,
        page: QlcTrendPage(),
      ),
    ]),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          _buildAppBar(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    //获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        margin: EdgeInsets.only(bottom: Adaptor.width(8)),
        width: double.infinity,
        child: PreferredSize(
          preferredSize: Size.fromHeight(Adaptor.height(Constant.barHeight)),
          child: Container(
            height: Adaptor.height(Constant.barHeight),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: Adaptor.width(6)),
                  child: Icon(
                    IconData(0xe68c, fontFamily: 'iconfont'),
                    size: Adaptor.sp(17),
                    color: Color(0xFF59575A),
                  ),
                ),
                Text(
                  '实用工具',
                  style: TextStyle(
                    fontSize: Adaptor.sp(18),
                    color: Color(0xFF59575A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: CustomScrollView(
          controller: scrollController,
          physics: EasyRefreshPhysics(topBouncing: false),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: Adaptor.width(16), bottom: 0),
                child: Image.asset('assets/images/means-header.png'),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: ContestTabHeader(
                height: Adaptor.height(100.0),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: VipNavigator(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  int count = means.length;
                  Animation animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  controller.forward();
                  return AnimateView(
                    child: _buildMeans(means[index]),
                    animation: animation,
                    controller: controller,
                  );
                },
                childCount: means.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeans(MeansInfo meansInfo) {
    List<Widget> items = [];
    for (int i = 0; i < meansInfo.items.length - 1; i++) {
      MeansItem item = meansInfo.items[i];
      items
        ..add(
          _buildToolItem(item.name, item.type, i == 0 ? 0 : Adaptor.width(20),
              Adaptor.width(20), callback: () {
            if (item.done) {
              AppNavigator.push(context, item.page);
              return;
            }
            EasyLoading.showToast('暂未开通');
          }),
        )
        ..add(
          Constant.verticleLine(
            width: Adaptor.width(0.6),
            height: Adaptor.height(10),
            color: Colors.black38,
          ),
        );
    }
    MeansItem last = meansInfo.items.last;
    items.add(
      _buildToolItem(last.name, last.type, Adaptor.width(20), 0, callback: () {
        if (last.done) {
          AppNavigator.push(context, last.page);
          return;
        }
        EasyLoading.showToast('暂未开通');
      }),
    );
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(15),
        0,
        Adaptor.width(15),
        Adaptor.width(20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Adaptor.width(16),
        vertical: Adaptor.width(8),
      ),
      decoration: BoxDecoration(
        color: Color(0xffF8F9FC),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          _toolHeader(meansInfo.name, meansInfo.image),
          Row(
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _toolHeader(String title, String img) {
    return Container(
      height: Adaptor.height(36),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: Adaptor.width(16)),
              child: Image.asset(
                img,
                width: Adaptor.width(30),
              ),
            ),
            Text(
              '$title',
              style: TextStyle(
                color: Color(0xFF59575A),
                fontSize: Adaptor.sp(16),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolItem(String name, String type, double left, double right,
      {Function callback}) {
    TextStyle style = new TextStyle(
      color: Colors.black54,
      height: 1.1,
      fontSize: Adaptor.sp(13),
    );
    if (this.current == type) {
      style = new TextStyle(
        color: Color(0xffF43F3B),
        height: 1.1,
        fontSize: Adaptor.sp(13),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          current = type;
        });
        if (callback != null) {
          callback();
        }
      },
      child: Container(
        height: Adaptor.height(24),
        margin: EdgeInsets.fromLTRB(
            left, Adaptor.width(8), right, Adaptor.width(8)),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(2.0),
        ),
        alignment: Alignment.center,
        child: Text(
          '$name',
          style: style,
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  final double height;

  ContestTabHeader({this.child, this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => this.height;

  @override
  double get minExtent => this.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MeansInfo {
  String name;

  String image;

  List<MeansItem> items;

  MeansInfo({this.name, this.image, this.items});
}

class MeansItem {
  ///名称
  String name;

  ///类型
  String type;

  ///是否开放
  bool done;

  ///页面名称
  Widget page;

  MeansItem({this.name, this.type, this.done = true, this.page});
}
