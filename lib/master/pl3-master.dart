import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/bottom_drag_widget.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/issue_notice.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/subscribe_widget.dart';
import 'package:lottery_app/detail/pl3_history_detail.dart';
import 'package:lottery_app/master/model/item-model.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/detail/pl3-detail.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/master/widgets/pl3_achieve_widget.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/global_config.dart';
import 'package:lottery_app/model/pl3_master.dart';
import 'package:provider/provider.dart';

class Pl3MasterPage extends StatefulWidget {
  String _masterId;

  final int index;

  Pl3MasterPage(this._masterId, {this.index: 1});

  @override
  Pl3MasterPageState createState() => new Pl3MasterPageState();
}

class Pl3MasterPageState extends State<Pl3MasterPage> {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider(
        create: (_) => Pl3MasterModel.initialize(masterId: widget._masterId),
        child: Scaffold(
          body: Container(
            color: Color(0xfff5f5f5),
            child: Column(
              children: <Widget>[
                MAppBar('专家详情'),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer2<GlobalConfigModel, Pl3MasterModel>(builder: (
      BuildContext context,
      GlobalConfigModel config,
      Pl3MasterModel model,
      Widget child,
    ) {
      if (config.state == LoadState.error) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              config.error(),
            ],
          ),
        );
      }
      if (model.state == LoadState.loading) {
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.loading(),
            ],
          ),
        );
      }
      if (model.state == LoadState.error) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                message: '出错啦，点击重试',
                callback: () {
                  model.loadData();
                },
              ),
            ],
          ),
        );
      }
      if (model.state == LoadState.success) {
        return BottomDragWidget(
          body: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.09),
            child: Column(
              children: <Widget>[
                if (model.detail.vip == 1)
                  IssueNotice(
                    notice:
                        '查看预测需${config.config.pl3Fee}金币，最多使用代金券抵扣${config.config.pl3Voucher}金币',
                  ),
                _buildMaster(model.detail),
                _buildHistory(model.history),
              ],
            ),
          ),
          dragContainer: DragContainer(
              drawer: Container(
                child: OverscrollNotificationWidget(
                  child: Pl3AchieveWidget(
                    record: model.records,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border.all(color: Color(0xfff1f1f1), width: 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xfff1f1f1),
                      offset: Offset(0.0, -1.0),
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                ),
              ),
              defaultShowHeight: MediaQuery.of(context).size.height * 0.09,
              height: MediaQuery.of(context).size.height * 0.60),
        );
      }
    });
  }

  ///创建专家信息组件
  Widget _buildMaster(Pl3MasterDetail detail) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
              Adaptor.width(25),
              Adaptor.width(16),
              Adaptor.width(10),
              Adaptor.width(16),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: Adaptor.width(70),
                    height: Adaptor.height(70),
                    margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(10), 0),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      width: Adaptor.width(70),
                      height: Adaptor.height(70),
                      fit: BoxFit.cover,
                      imageUrl: detail.image,
                      placeholder: (context, uri) => Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(left: Adaptor.width(10)),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(bottom: Adaptor.width(10)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Tools.limitName(detail.name, 8),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: Adaptor.sp(22)),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SubScribeWidget(
                              type: 'pl3',
                              master: detail.masterId,
                              subscribe: detail.subscribe,
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {
                                  AppNavigator.push(
                                    context,
                                    detail.updated == 1
                                        ? Pl3DetailPage(
                                            masterId: detail.masterId,
                                          )
                                        : Pl3HistoryDetailPage(
                                            masterId: detail.masterId,
                                          ),
                                    login: true,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    Adaptor.width(6),
                                    Adaptor.width(2),
                                    Adaptor.width(6),
                                    Adaptor.width(2),
                                  ),
                                  height: Adaptor.height(28),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xffFF421A),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(3.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        detail.updated == 1 ? '最新预测' : '上期历史',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Adaptor.sp(15),
                                        ),
                                      ),
                                      Icon(
                                        IconData(
                                            detail.updated == 1
                                                ? 0xe602
                                                : 0xe642,
                                            fontFamily: 'iconfont'),
                                        size: Adaptor.sp(15),
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  flex: 3,
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: Adaptor.height(30),
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      _buildRate('三胆', detail.hit3, Adaptor.width(10)),
                      _buildRate('六码', detail.hit6, 0),
                      _buildRate('七码', detail.hit7, 0),
                      _buildRate('杀一', detail.kill1Hit, 0),
                      _buildRate('杀二', detail.kill2Hit, 0),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRate(String name, String hit, double margin) {
    return new Container(
      margin: EdgeInsets.fromLTRB(margin, 0, Adaptor.width(12), 0),
      padding: EdgeInsets.fromLTRB(Adaptor.width(6), 0, Adaptor.width(6), 0),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Row(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              color: Colors.black54,
              fontSize: Adaptor.sp(13),
            ),
          ),
          Text(
            hit,
            style: TextStyle(
              color: Color(0xFFFF512F),
              fontSize: Adaptor.sp(13),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHistory(Pl3History history) {
    if (history.dan1.length > 0) {
      return Expanded(
        child: new Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: Adaptor.width(10)),
          child: Column(
            children: <Widget>[
              TabBar(
                  controller: _tabController,
                  tabs: _buildTabs(),
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: Adaptor.width(10)),
                  indicatorWeight: 0,
                  isScrollable: true,
                  labelColor: Color(0xFFF83600),
                  labelStyle: TextStyle(
                      fontSize: Adaptor.sp(14), fontWeight: FontWeight.w500),
                  unselectedLabelStyle: TextStyle(fontSize: Adaptor.sp(14)),
                  indicator: new BoxDecoration(),
                  unselectedLabelColor: Colors.black54),
              new Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _buildTabPage(history),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: null,
      );
    }
  }

  List<Tab> _buildTabs() {
    return <Tab>[
      Tab(text: '杀一'),
      Tab(text: '七码'),
      Tab(text: '六码'),
      Tab(text: '杀二'),
      Tab(text: '五码'),
      Tab(text: '三胆'),
      Tab(text: '双胆'),
      Tab(text: '独胆'),
      Tab(text: '定位五'),
    ];
  }

  List<Widget> _buildTabPage(Pl3History history) {
    return <Widget>[
      _buildPage(context, history.kill1, showHit: true),
      _buildPage(context, history.com7),
      _buildPage(context, history.com6),
      _buildPage(context, history.kill2, showHit: true),
      _buildPage(context, history.com5),
      _buildPage(context, history.dan3),
      _buildPage(context, history.dan2),
      _buildPage(context, history.dan1, showHit: true),
      _buildPage(context, history.comb5, showHit: true),
    ];
  }

  ///创建tab切换页面
  Widget _buildPage(BuildContext context, List<ItemVo> data,
      {bool showHit: false}) {
    if (data.length > 0) {
      return Container(
        color: Color(0x04000000),
        child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, Adaptor.width(30)),
            itemCount: data.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(data, index, showHit: showHit);
            }),
      );
    }
    return Container(
      child: null,
    );
  }

  //创建list item项
  Widget _buildItem(List<ItemVo> data, int index, {bool showHit: false}) {
    ItemVo item = data[index];
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(
              Adaptor.width(12),
              Adaptor.width(4),
              Adaptor.width(12),
              Adaptor.width(2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '第${item.period}期',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: Adaptor.sp(15),
                  ),
                ),
                item.hit > 0
                    ? Text(
                        showHit ? '命中' : '中${item.hit}',
                        style: TextStyle(
                          color: Color(0xffF43F3B),
                          fontSize: Adaptor.sp(15),
                        ),
                      )
                    : Text(
                        '未命中',
                        style: TextStyle(
                          color: Color(0xffF43F3B),
                          fontSize: Adaptor.sp(15),
                        ),
                      )
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(
              Adaptor.width(12),
              0,
              Adaptor.width(12),
              Adaptor.width(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(right: Adaptor.width(8)),
                  child: Text(
                    '预测数据',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: Adaptor.sp(14),
                        height: 1.25),
                  ),
                ),
                Expanded(
                    child: new Wrap(
                  children: _hitViews(item.values),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _hitViews(List<Model> data) {
    List<Widget> views = new List();
    data.forEach((item) {
      if (item.v == 0) {
        views.add(new Container(
          margin: EdgeInsets.only(
            right: Adaptor.width(8),
          ),
          child: Text(
            item.k,
            style: TextStyle(
              color: Colors.black54,
              fontSize: Adaptor.sp(16),
            ),
          ),
        ));
      } else {
        views.add(new Container(
          margin: EdgeInsets.only(
            right: Adaptor.width(8),
          ),
          child: Text(
            item.k,
            style: TextStyle(
              color: Color(0xffF43F3B),
              fontSize: Adaptor.sp(16),
            ),
          ),
        ));
      }
    });
    return views;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: ScrollableState());
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
