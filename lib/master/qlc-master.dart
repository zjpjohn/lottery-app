import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/issue_notice.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/subscribe_widget.dart';
import 'package:lottery_app/detail/qlc_history_detail.dart';
import 'package:lottery_app/master/model/item-model.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/detail/qlc-detail.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/bottom_drag_widget.dart';
import 'package:lottery_app/master/widgets/qlc_achieve_widget.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/model/global_config.dart';
import 'package:lottery_app/model/qlc_master.dart';
import 'package:provider/provider.dart';

class QlcMasterPage extends StatefulWidget {
  String _masterId;

  int index;

  QlcMasterPage(this._masterId, {this.index = 6});

  @override
  QlcMasterPageState createState() => new QlcMasterPageState();
}

class QlcMasterPageState extends State<QlcMasterPage> {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ChangeNotifierProvider<QlcMasterModel>(
        create: (_) => QlcMasterModel.initialize(masterId: widget._masterId),
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
    return Consumer2<GlobalConfigModel, QlcMasterModel>(
      builder: (
        BuildContext context,
        GlobalConfigModel global,
        QlcMasterModel model,
        Widget child,
      ) {
        if (global.state == LoadState.error) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                global.error(),
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
                          '查看预测需${global.config.qlcFee}金币，最多使用代金券抵扣${global.config.qlcVoucher}金币',
                    ),
                  _buildMaster(model.detail),
                  _buildHistory(model.history),
                ],
              ),
            ),
            dragContainer: DragContainer(
                drawer: Container(
                  child: OverscrollNotificationWidget(
                    child: QlcAchieveWidget(record: model.records),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xfff1f1f1),
                      width: Adaptor.width(0.2),
                    ),
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
      },
    );
  }

  ///创建专家信息组件
  Widget _buildMaster(QlcMasterDetail detail) {
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
                              type: 'qlc',
                              master: detail.masterId,
                              subscribe: detail.subscribe,
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {
                                  AppNavigator.push(
                                    context,
                                    detail.updated == 1
                                        ? QlcDetailPage(
                                            masterId: detail.masterId,
                                          )
                                        : QlcHistoryDetailPage(
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
                                      Adaptor.width(2)),
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
                      _buildRate('三胆', detail.red3Hit, Adaptor.width(10)),
                      _buildRate('12码', detail.red12Hit, 0),
                      _buildRate('18码', detail.red18Hit, 0),
                      _buildRate('22码', detail.red22Hit, 0),
                      _buildRate('杀三', detail.kill3Hit, 0),
                      _buildRate('杀六', detail.kill6Hit, 0),
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
        borderRadius: BorderRadius.circular(3.0),
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

  Widget _buildHistory(QlcHistory history) {
    if (history.dan1.length > 0) {
      return Expanded(
        child: new Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: Adaptor.width(10)),
          child: Column(
            children: <Widget>[
              TabBar(
                  controller: _tabController,
                  tabs: _buildTab(),
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

  List<Tab> _buildTab() {
    return <Tab>[
      Tab(text: '22码'),
      Tab(text: '18码'),
      Tab(text: '杀三'),
      Tab(text: '12码'),
      Tab(text: '杀六'),
      Tab(text: '三胆'),
      Tab(text: '双胆'),
      Tab(text: '独胆'),
    ];
  }

  List<Widget> _buildTabPage(QlcHistory history) {
    return <Widget>[
      _buildPage(context, history.red22),
      _buildPage(context, history.red18),
      _buildPage(context, history.kill3, showHit: true),
      _buildPage(context, history.red12),
      _buildPage(context, history.kill6, showHit: true),
      _buildPage(context, history.dan3),
      _buildPage(context, history.dan2),
      _buildPage(context, history.dan1, showHit: true),
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
          Container(
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
                      color: Colors.black54, fontSize: Adaptor.sp(15)),
                ),
                item.hit > 0
                    ? Text(showHit ? '命中' : '中${item.hit}',
                        style: TextStyle(
                            color: Color(0xffF43F3B), fontSize: Adaptor.sp(15)))
                    : Text(
                        '未命中',
                        style: TextStyle(
                            color: Color(0xffF43F3B), fontSize: Adaptor.sp(15)),
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
          margin: EdgeInsets.only(right: Adaptor.width(8)),
          child: Text(
            item.k,
            style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(16)),
          ),
        ));
      } else {
        views.add(new Container(
          margin: EdgeInsets.only(right: Adaptor.width(8)),
          child: Text(
            item.k,
            style:
                TextStyle(color: Color(0xffF43F3B), fontSize: Adaptor.sp(16)),
          ),
        ));
      }
    });
    return views;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: ScrollableState());
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
