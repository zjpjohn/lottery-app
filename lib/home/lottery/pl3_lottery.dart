import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/bigshot/pl3_bigshot.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:lottery_app/commons/animate_view.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/ball_view.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/components/rank_master_view.dart';
import 'package:lottery_app/components/tag_mark.dart';
import 'package:lottery_app/components/vip_nav_button.dart';
import 'package:lottery_app/glad/pl3-glad.dart';
import 'package:lottery_app/master/pl3-master.dart';
import 'package:lottery_app/model/pl3_lottery.dart';
import 'package:lottery_app/overall/pl3_overall.dart';
import 'package:lottery_app/picker/pl3-picker.dart';
import 'package:lottery_app/compare/pl3-compare.dart';
import 'package:lottery_app/rank/pl3-ranks.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_card.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/comprehensive/pl3_chart.dart';

class Pl3LotteryPage extends StatefulWidget {
  Pl3LotteryModel model;

  Pl3LotteryPage(this.model);

  @override
  Pl3LotteryPageState createState() => new Pl3LotteryPageState();
}

class Pl3LotteryPageState extends State<Pl3LotteryPage>
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
            padding: EdgeInsets.only(top: Adaptor.width(16), bottom: 0),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              Animation animation = Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / 3) * index, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              );
              controller.forward();
              return AnimateView(
                animation: animation,
                controller: controller,
                child: _itemView(index),
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

  Widget _itemView(int index) {
    if (index == 0) {
      return _itemLottery();
    }
    if (index == 1) {
      return _masterView();
    }
    if (index == 2) {
      return _gladsView();
    }
  }

  Widget _masterView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Adaptor.width(12)),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[]..add(_rankMaster()),
      ),
    );
  }

  Widget _gladsView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: Adaptor.width(12),
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[]
          ..add(_gladHeader())
          ..addAll(
            List.of(widget.model.glads).map((item) {
              return _gladView(item);
            }),
          ),
      ),
    );
  }

  Widget _gladView(var item) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Adaptor.width(16), 0, Adaptor.width(16), Adaptor.width(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(0xFFF8F8F8),
        ),
        alignment: Alignment.center,
        child: new InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              Pl3MasterPage(
                item['masterId'],
                index: 3,
              ),
              login: true,
            );
          },
          child: Row(
            children: <Widget>[
              Container(
                width: Adaptor.width(56),
                height: Adaptor.height(56),
                margin: EdgeInsets.fromLTRB(
                    Adaptor.width(14), 0, Adaptor.width(16), 0),
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  width: Adaptor.width(56),
                  height: Adaptor.height(56),
                  fit: BoxFit.cover,
                  imageUrl: item['image'],
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
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, Adaptor.width(10),
                      Adaptor.width(10), Adaptor.width(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: Adaptor.width(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              Tools.limitName(item['name'], 8),
                              style: TextStyle(
                                  color: Color(0xff5c5c5c),
                                  fontSize: Adaptor.sp(14)),
                            ),
                            new Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '详情',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Adaptor.sp(12)),
                                  ),
                                  Icon(
                                    IconData(0xe602, fontFamily: 'iconfont'),
                                    size: Adaptor.sp(13),
                                    color: Colors.black38,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: Adaptor.width(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getRate(item),
                        ),
                      ),
                      new Container(
                        child: Row(
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(right: Adaptor.width(5)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '三胆',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Adaptor.sp(13)),
                                  ),
                                  Text(
                                    item['dan3'],
                                    style: TextStyle(
                                        color: Color(0xffF43F3B),
                                        fontSize: Adaptor.sp(13)),
                                  )
                                ],
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(right: Adaptor.width(5)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '杀一码',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Adaptor.sp(13)),
                                  ),
                                  Text(
                                    item['kill1'],
                                    style: TextStyle(
                                        color: Color(0xffF43F3B),
                                        fontSize: Adaptor.sp(13)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getRate(var item) {
    List<Widget> views = <Widget>[];
    if (item['dan3Rate'] >= 0.75) {
      views.add(MarkView(name: '三胆'));
    }
    if (item['com7Rate'] >= 0.8) {
      views.add(MarkView(name: '七码'));
    }
    if (item['kill1Rate'] >= 0.8) {
      views.add(MarkView(name: '杀一'));
    }
    if (item['kill2Rate'] >= 0.8) {
      views.add(MarkView(name: '杀二'));
    }
    if (views.length == 0) {
      views.add(MarkView(name: '加油中'));
    }
    return views;
  }

  Widget _gladHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Adaptor.width(16)),
      child: InkWell(
        onTap: () {
          AppNavigator.push(context, Pl3GladPage());
        },
        child: new Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            left: Adaptor.width(2),
            bottom: Adaptor.width(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '中奖专家',
                    style: TextStyle(
                      color: Color(0xff59575A),
                      fontSize: Adaptor.sp(18),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                flex: 3,
              ),
              Expanded(
                child: new Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '更多中奖',
                          style: TextStyle(
                              color: Colors.black38, fontSize: Adaptor.sp(12)),
                        ),
                        Icon(
                          IconData(0xe602, fontFamily: 'iconfont'),
                          size: Adaptor.sp(13),
                          color: Colors.black38,
                        )
                      ],
                    )),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemLottery() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Adaptor.width(14), 0, Adaptor.width(14), Adaptor.width(16)),
      child: CCard(
        color: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.25),
        borderRadius: 6.0,
        blurRadius: 16.0,
        offset: Offset(4.0, 4.0),
        child: Container(
          padding:
              EdgeInsets.fromLTRB(0, Adaptor.width(12), 0, Adaptor.width(4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: Adaptor.width(16)),
                margin: EdgeInsets.only(bottom: Adaptor.width(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: Adaptor.width(35)),
                      child: Text(
                        widget.model.lottery != null
                            ? widget.model.lottery['name']
                            : '排列三',
                        style: TextStyle(
                            color: Color(0xFF5c5c5c),
                            fontSize: Adaptor.sp(16),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: Adaptor.width(16)),
                      child: Text(
                        widget.model.lottery != null
                            ? widget.model.lottery['period'] + '期'
                            : '',
                        style: TextStyle(
                            fontSize: Adaptor.sp(15), color: Color(0xff5c5c5c)),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: Adaptor.width(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _ballView(
                          widget.model.lottery != null
                              ? widget.model.lottery['redBalls']
                              : null,
                          widget.model.lottery != null
                              ? widget.model.lottery['blueBalls']
                              : null,
                          false,
                        ),
                      ),
                      flex: (widget.model.lottery != null &&
                              widget.model.lottery['shiBalls'] != null)
                          ? 1
                          : 4,
                    ),
                    Expanded(
                      child: (widget.model.lottery != null &&
                              widget.model.lottery['shiBalls'] != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _ballView(
                                widget.model.lottery['shiBalls'],
                                null,
                                true,
                              ),
                            )
                          : Container(),
                      flex: 1,
                    )
                  ],
                ),
              ),
              _buttons()
            ],
          ),
        ),
      ),
    );
  }

  ///vip专家排行榜
  ///#FD7164->#FD9E8A
  Widget _rankMaster() {
    return Container(
      margin: EdgeInsets.fromLTRB(Adaptor.width(16), Adaptor.width(4),
          Adaptor.width(16), Adaptor.width(12)),
      child: CCard(
        shadowColor: Color(0xffececec),
        blurRadius: 16.0,
        borderRadius: 4.0,
        offset: Offset(0.0, 3.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xfffd7164), Color(0xfffd9e8a)],
                ),
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(4.0),
                  topEnd: Radius.circular(4.0),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(Adaptor.width(4), 0, 0, 0),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black12,
                            Color(0x04000000),
                          ],
                        ).createShader(Offset.zero & bounds.size);
                      },
                      child: Text(
                        'TOP',
                        style: TextStyle(
                            fontSize: Adaptor.sp(34),
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(Adaptor.width(12),
                        Adaptor.width(6), Adaptor.width(10), Adaptor.width(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(Adaptor.width(4), 0, 0, 0),
                          child: Text(
                            '排行榜',
                            style: TextStyle(
                              fontSize: Adaptor.sp(19),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: Adaptor.width(4)),
                              child: Text(
                                '优质精品专家出炉!',
                                style: TextStyle(
                                  fontSize: Adaptor.sp(14),
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                AppNavigator.push(context, Pl3RanksPage());
                              },
                              child: Container(
                                height: Adaptor.height(22),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '查看更多',
                                      style: TextStyle(
                                        fontSize: Adaptor.sp(12),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      IconData(0xe602, fontFamily: 'iconfont'),
                                      size: Adaptor.sp(12),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, Adaptor.width(16), 0, Adaptor.width(8)),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                children: _rankView(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _rankView() {
    List<Widget> views = List();
    for (int i = 0; i < widget.model.masters.length; i++) {
      var master = widget.model.masters[i];
      Widget view = RankMasterView(
        name: master['name'],
        avatar: master['image'],
        margin: EdgeInsets.only(right: i % 2 == 0 ? Adaptor.width(16) : 0),
        rank: master['rank'],
        colors: i < 3 ? Constant.redColors : Constant.grayColors,
        onTap: () {
          AppNavigator.push(
            context,
            Pl3MasterPage(
              master['masterId'],
              index: 6,
            ),
            login: true,
          );
        },
      );
      views.add(view);
    }
    return views;
  }

  Widget _buttons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Adaptor.width(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          VipNavButton(
            name: '专家PK',
            icon: 'assets/images/pk.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, Pl3ComparePage(), login: true);
            },
          ),
          VipNavButton(
            name: '综合分析',
            icon: 'assets/images/analysis.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, Pl3ComprehensivePage(), login: true);
            },
          ),
          VipNavButton(
            name: '热门精选',
            icon: 'assets/images/hot.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, Pl3PickerPage(), login: true);
            },
          ),
          VipNavButton(
            name: '臻选牛人',
            icon: 'assets/images/choice.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, Pl3BigshotPage(), login: true);
            },
          ),
          VipNavButton(
            name: '整体态势',
            icon: 'assets/images/situation.png',
            margin:
                EdgeInsets.fromLTRB(0, Adaptor.width(12), 0, Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, Pl3OverallPage(), login: true);
            },
          ),
        ],
      ),
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
              fontSize: Adaptor.sp(14),
              color: Colors.black38,
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

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 750), vsync: this);
    super.initState();
    Future.delayed(Duration(milliseconds: 60), () {
      widget.model.loadData();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
