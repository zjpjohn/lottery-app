import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/animate_view.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/history/fc3d-lottery-history.dart';
import 'package:lottery_app/history/pl3-lottery-history.dart';
import 'package:lottery_app/history/ssq-lottery-history.dart';
import 'package:lottery_app/history/dlt-lottery-history.dart';
import 'package:lottery_app/history/qlc-lottery-history.dart';
import 'package:lottery_app/model/lotteries.dart';
import 'package:lottery_app/shrink/dlt_shrink.dart';
import 'package:lottery_app/shrink/fc3d_shrink.dart';
import 'package:lottery_app/shrink/pl3_shrink.dart';
import 'package:lottery_app/shrink/qlc_shrink.dart';
import 'package:lottery_app/shrink/ssq_shrink.dart';
import 'package:lottery_app/table/fc3d-table.dart';
import 'package:lottery_app/table/pl3-table.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_card.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/ball_view.dart';

class LotteriesPage extends StatefulWidget {
  LotteriesModel model;

  LotteriesPage(this.model);

  @override
  LotteriesPageState createState() => new LotteriesPageState();
}

class LotteriesPageState extends State<LotteriesPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.model.state == LoadState.loading) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      );
    }
    if (widget.model.state == LoadState.error) {
      return ErrorView(
          message: '出错啦，点击重试',
          callback: () {
            widget.model.loadData();
          });
    }
    if (widget.model.state == LoadState.success) {
      return Center(
        child: EasyRefresh(
          header: DeliveryHeader(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: Adaptor.width(16)),
            itemCount: widget.model.lotteries.length,
            itemBuilder: (BuildContext context, int index) {
              int count = widget.model.lotteries.length;
              Animation animation = Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              );
              controller.forward();
              return AnimateView(
                child: _itemView(context, index),
                animation: animation,
                controller: controller,
              );
            },
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 3), () {
              widget.model.loadData();
            });
          },
        ),
      );
    }
  }

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      widget.model.loadData();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buttons(String type) {
    if (type == 'fucai_3d' || type == 'pai_lie3') {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Adaptor.width(8)),
            child: InkWell(
              onTap: () {
                Widget page;
                if (type == 'fucai_3d') {
                  page = Fc3dLotteryHistory();
                } else {
                  page = Pl3LotteryHistory();
                }
                AppNavigator.push(context, page);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0,
                  Adaptor.width(5),
                  Adaptor.width(8),
                  Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '历史开奖',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
          Constant.verticleLine(
            width: Adaptor.width(0.6),
            height: Adaptor.height(10),
            color: Colors.black26,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Adaptor.width(8)),
            child: InkWell(
              onTap: () {
                EasyLoading.showToast('暂未开通');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '号码推荐',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
          Constant.verticleLine(
            width: Adaptor.width(0.6),
            height: Adaptor.height(10),
            color: Colors.black26,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Adaptor.width(8)),
            child: InkWell(
              onTap: () {
                Widget page;
                if (type == 'fucai_3d') {
                  page = Fc3dTablePage();
                } else {
                  page = Pl3TablePage();
                }
                AppNavigator.push(context, page);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '速查表',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
          Constant.verticleLine(
            width: Adaptor.width(0.6),
            height: Adaptor.height(10),
            color: Colors.black26,
          ),
          Container(
            margin: EdgeInsets.only(left: Adaptor.width(8)),
            child: InkWell(
              onTap: () {
                Widget page;
                if (type == 'fucai_3d') {
                  page = Fc3dShrinkPage();
                } else {
                  page = Pl3ShrinkPage();
                }
                AppNavigator.push(context, page);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '缩水选号',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (type == 'shuang_se_qiu' || type == 'da_le_tou' || type == 'qi_le_cai') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Adaptor.width(8)),
            child: new InkWell(
              onTap: () {
                Widget page;
                if (type == 'shuang_se_qiu') {
                  page = SsqLotteryHistory();
                } else if (type == 'da_le_tou') {
                  page = DltLotteryHistory();
                } else {
                  page = QlcLotteryHistory();
                }
                AppNavigator.push(context, page);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0,
                  Adaptor.width(5),
                  Adaptor.width(8),
                  Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '历史开奖',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
          Constant.verticleLine(
            width: Adaptor.width(0.6),
            height: Adaptor.height(10),
            color: Colors.black26,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Adaptor.width(8)),
            child: InkWell(
              onTap: () {
                EasyLoading.showToast('暂未开通');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '号码推荐',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
          Constant.verticleLine(
            width: Adaptor.width(0.6),
            height: Adaptor.height(10),
            color: Colors.black26,
          ),
          Container(
            margin: EdgeInsets.only(left: Adaptor.width(8)),
            child: InkWell(
              onTap: () {
                Widget page;
                if (type == 'shuang_se_qiu') {
                  page = SsqShrinkPage();
                } else if (type == 'da_le_tou') {
                  page = DltShrinkPage();
                } else {
                  page = QlcShrinkPage();
                }
                AppNavigator.push(context, page);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adaptor.width(8),
                  vertical: Adaptor.width(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '缩水选号',
                  style: TextStyle(
                    height: 1.1,
                    color: Color(0xff59575A),
                    fontSize: Adaptor.sp(13),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _itemView(BuildContext context, int index) {
    var item = widget.model.lotteries[index];
    return Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(14),
        Adaptor.width(index == 0 ? 0 : 8),
        Adaptor.width(14),
        Adaptor.width(10),
      ),
      child: CCard(
          color: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.12),
          borderRadius: 6.0,
          blurRadius: 16.0,
          offset: Offset(4.0, 4.0),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptor.width(12), vertical: Adaptor.width(14)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: Adaptor.width(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: Adaptor.width(35)),
                        child: Text(
                          item['name'],
                          style: TextStyle(
                              color: Color(0xff59575A),
                              fontSize: Adaptor.sp(17),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Text(
                          item['period'] + '期',
                          style: TextStyle(
                            fontSize: Adaptor.sp(15),
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Adaptor.width(16)),
                  child: Row(
                    mainAxisAlignment: item['shiBalls'] != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _ballView(
                              item['redBalls'], item['blueBalls'], false),
                        ),
                        flex: 1,
                      ),
                      item['shiBalls'] != null
                          ? Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                    _ballView(item['shiBalls'], null, true),
                              ),
                              flex: 1,
                            )
                          : Offstage(
                              offstage: true,
                            )
                    ],
                  ),
                ),
                _buttons(item['type'])
              ],
            ),
          )),
    );
  }

  List<Widget> _ballView(List reds, List blues, bool shi) {
    List<Widget> views = <Widget>[];
    List<String> items;
    if (reds == null) {
      items = ['待', '开', '奖'];
    } else {
      items = List<String>.from(reds);
    }
    if (shi) {
      views.add(
        Container(
          margin: EdgeInsets.only(right: Adaptor.width(5)),
          child: Text(
            '试机号',
            style: TextStyle(
              fontSize: Adaptor.sp(13),
              color: Colors.black54,
            ),
          ),
        ),
      );
    }
    items.forEach((ball) {
      views.add(BallView(
        ball: ball,
        type: BallType.red,
      ));
    });
    if (blues != null) {
      List<String> bBalls = List<String>.from(blues);
      bBalls.forEach((ball) {
        views.add(BallView(
          ball: ball,
          type: BallType.blue,
        ));
      });
    }
    return views;
  }
}
