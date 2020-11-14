import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/list/items/ssq-high-list.dart';
import 'package:lottery_app/list/items/ssq-low-list.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';

class SsqLitPage extends StatefulWidget {
  int _type;

  String _name;

  SsqLitPage(this._type, this._name);

  @override
  SsqLitPageState createState() => new SsqLitPageState();
}

class SsqLitPageState extends State<SsqLitPage> {
  //tab选项
  List<Widget> _tabs = <Widget>[
    Container(
      child: Text('精准专家'),
    ),
    Container(
      child: Text('普通专家'),
    )
  ];

  //页面
  List<Widget> _views;

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(context),
            _buildBreadcrumb(context),
            Expanded(
                child: TabBarView(controller: _tabController, children: _views))
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    //获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      width: double.infinity,
      height: Constant.barHeight + statusBarHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        const Color(0xFFFE8C00),
        const Color(0xFFF83600),
      ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: new InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: new Container(
                height: Adaptor.height(32),
                width: Adaptor.width(32),
                padding: EdgeInsets.only(left: Adaptor.width(20)),
                alignment: Alignment.centerLeft,
                child: Icon(
                  IconData(Constant.backIcon, fontFamily: 'iconfont'),
                  size: Adaptor.sp(17),
                  color: Colors.white70,
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: new Container(
              child: TabBar(
                tabs: _tabs,
                controller: _tabController,
                labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                isScrollable: false,
                labelColor: Color(0xffffcc33),
                labelStyle:
                    TextStyle(fontSize: Adaptor.sp(20), fontWeight: FontWeight.w500),
                unselectedLabelStyle:
                    TextStyle(fontSize: Adaptor.sp(20), fontWeight: FontWeight.w500),
                indicator: new BoxDecoration(),
                unselectedLabelColor: Colors.white,
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(''),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(left: Adaptor.width(10)),
      height: Adaptor.height(38),
      color: Color(0x00f1f1f1),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            '双色球',
            style: TextStyle(color: Color(0xff7c7c7c), fontSize: Adaptor.sp(14)),
          ),
          Icon(
            IconData(0xe602, fontFamily: 'iconfont'),
            size: Adaptor.sp(17),
            color: Color(0xff7c7c7c),
          ),
          Text(
            widget._name,
            style: TextStyle(color: Color(0xff7c7c7c), fontSize: Adaptor.sp(14)),
          ),
          Icon(
            IconData(0xe602, fontFamily: 'iconfont'),
            size: Adaptor.sp(17),
            color: Color(0xff7c7c7c),
          ),
          Text(
            '专家排行榜',
            style: TextStyle(color: Color(0xff7c7c7c), fontSize: Adaptor.sp(14)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _views = <Widget>[SsqHighList(widget._type), SsqLowList(widget._type)];
    _tabController =
        TabController(length: _tabs.length, vsync: ScrollableState());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
