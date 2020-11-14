import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/bigshot/ssq_bigshot.dart';
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
import 'package:lottery_app/glad/ssq-glad.dart';
import 'package:lottery_app/master/ssq-master.dart';
import 'package:lottery_app/model/ssq_lottery.dart';
import 'package:lottery_app/overall/ssq_overall.dart';
import 'package:lottery_app/picker/ssq-picker.dart';
import 'package:lottery_app/compare/ssq-compare.dart';
import 'package:lottery_app/rank/ssq-ranks.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_card.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/comprehensive/ssq_chart.dart';

class SsqLotteryPage extends StatefulWidget {
  SsqLotteryModel model;

  SsqLotteryPage(this.model);

  @override
  SsqLotteryPageState createState() => new SsqLotteryPageState();
}

class SsqLotteryPageState extends State<SsqLotteryPage>
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
      return new Center(
        child: new EasyRefresh(
          header: DeliveryHeader(),
          child: ListView.builder(
            padding: EdgeInsets.only(top: Adaptor.width(16), bottom: 0),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              Animation animation = Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / 4) * index, 1.0,
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
      return _redMasterView();
    }
    if (index == 2) {
      return _blueMasterView();
    }
    if (index == 3) {
      return _gladsView();
    }
  }

  Widget _redMasterView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Adaptor.width(12)),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[]..add(
            _rankMasters(
              widget.model.rMasters,
              [Color(0xfffd7164), Color(0xfffd9e8a)],
              0,
              1,
              Adaptor.width(4),
              Adaptor.width(8),
            ),
          ),
      ),
    );
  }

  Widget _blueMasterView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: Adaptor.width(12)),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[]..add(
            _rankMasters(
              widget.model.bMasters,
              [Color(0xff6caff6), Color(0xff9DC9FA)],
              1,
              2,
              Adaptor.width(0),
              Adaptor.width(12),
            ),
          ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xFFF8F8F8),
      ),
      margin: EdgeInsets.fromLTRB(
          Adaptor.width(16), 0, Adaptor.width(16), Adaptor.width(12)),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          AppNavigator.push(
            context,
            SsqMasterPage(item['masterId'], index: 1),
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
              child: new Container(
                margin: EdgeInsets.fromLTRB(
                    0, Adaptor.width(10), Adaptor.width(10), Adaptor.width(10)),
                child: Column(
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
                            margin: EdgeInsets.only(right: 5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '红球大底',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: Adaptor.sp(13)),
                                ),
                                Text(
                                  item['red25'],
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
                                  '蓝球',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: Adaptor.sp(13)),
                                ),
                                Text(
                                  item['blue5'],
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
    );
  }

  List<Widget> _getRate(var item) {
    List<Widget> views = <Widget>[];
    if (item['red25Rate'] >= 0.5) {
      views.add(MarkView(name: '围红'));
    }
    if (item['kill3Rate'] >= 0.65) {
      views.add(MarkView(
        name: '杀红',
      ));
    }
    if (item['blueKillRate'] >= 0.8) {
      views.add(MarkView(
        name: '杀蓝',
      ));
    }
    if (views.length == 0) {
      views.add(MarkView(
        name: '加油中',
      ));
    }
    return views;
  }

  Widget _gladHeader() {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: Adaptor.width(16)),
      child: new InkWell(
        onTap: () {
          AppNavigator.push(context, SsqGladPage());
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
                child: new Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '中奖专家',
                    style: TextStyle(
                        color: Color(0xff59575A),
                        fontSize: Adaptor.sp(18),
                        fontWeight: FontWeight.w400),
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
                            : '双色球',
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
                            fontSize: Adaptor.sp(16), color: Color(0xff5c5c5c)),
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
                      child: new Container(
                        margin: EdgeInsets.only(right: Adaptor.width(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _ballView(
                              widget.model.lottery != null
                                  ? widget.model.lottery['redBalls']
                                  : null,
                              widget.model.lottery != null
                                  ? widget.model.lottery['blueBalls']
                                  : null),
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
                          ? new Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _ballView(
                                    widget.model.lottery['shiBalls'], null),
                              ),
                            )
                          : new Container(),
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

  Widget _rankMasters(
    List masters,
    List<Color> colors,
    int type,
    int index,
    double top,
    double bottom,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Adaptor.width(16), top, Adaptor.width(16), bottom),
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
                  colors: colors,
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
                                AppNavigator.push(context, SsqRanksPage(type));
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
                alignment: WrapAlignment.spaceBetween,
                children: _rankView(masters, index),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _rankView(List masters, int index) {
    List<Widget> views = List();
    for (int i = 0; i < masters.length; i++) {
      var master = masters[i];
      Widget view = RankMasterView(
        name: master['name'],
        avatar: master['image'],
        margin: EdgeInsets.only(right: i % 2 == 0 ? Adaptor.width(16) : 0),
        rank: master['rank'],
        colors: i < 3 ? Constant.redColors : Constant.grayColors,
        onTap: () {
          AppNavigator.push(
            context,
            SsqMasterPage(
              master['masterId'],
              index: index,
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
              AppNavigator.push(context, SsqComparePage(), login: true);
            },
          ),
          VipNavButton(
            name: '综合分析',
            icon: 'assets/images/analysis.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, SsqComprehensivePage(), login: true);
            },
          ),
          VipNavButton(
            name: '热门精选',
            icon: 'assets/images/hot.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, SsqPickerPage(), login: true);
            },
          ),
          VipNavButton(
            name: '臻选牛人',
            icon: 'assets/images/choice.png',
            margin: EdgeInsets.fromLTRB(
                0, Adaptor.width(12), Adaptor.width(12), Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, SsqBigshotPage(), login: true);
            },
          ),
          VipNavButton(
            name: '整体态势',
            icon: 'assets/images/situation.png',
            margin:
                EdgeInsets.fromLTRB(0, Adaptor.width(12), 0, Adaptor.width(6)),
            onTap: () {
              AppNavigator.push(context, SsqOverallPage(), login: true);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _ballView(List reds, List blues) {
    List<Widget> views = <Widget>[];
    List<String> items;
    if (reds == null) {
      items = ['待', '开', '奖'];
    } else {
      items = List<String>.from(reds);
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
        duration: Duration(milliseconds: 1000), vsync: this);
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
