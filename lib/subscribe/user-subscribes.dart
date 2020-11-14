import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/components/tag_mark.dart';
import 'package:lottery_app/components/vip_navigator.dart';
import 'package:lottery_app/master/fc3d-master.dart';
import 'package:lottery_app/master/pl3-master.dart';
import 'package:lottery_app/master/ssq-master.dart';
import 'package:lottery_app/master/dlt-master.dart';
import 'package:lottery_app/master/qlc-master.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottery_app/components/adaptor.dart';

class UserSubscribePage extends StatefulWidget {
  @override
  UserSubscribePageState createState() => new UserSubscribePageState();
}

class UserSubscribePageState extends State<UserSubscribePage> {
  ///默认显示
  String _type = 'fc3d';

  //是否正在加载
  bool loading = false;

  ///加载是否出错
  bool _error = false;

  ///每页数据大小
  int _limit = 8;

  var _controller = new ScrollController();

  var _scrollController = new ScrollController();

  ///关注专家集合
  Map<String, SubscribeModel> subscribes = Map();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            NavAppBar(
              title: '我的收藏',
              fontColor: Color(0xFF59575A),
              left: Container(
                height: Adaptor.height(32),
                width: Adaptor.width(32),
                alignment: Alignment.centerLeft,
                child: Icon(
                  IconData(Constant.backIcon, fontFamily: 'iconfont'),
                  size: Adaptor.sp(16),
                  color: Color(0xFF59575A),
                ),
              ),
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  ///创建内容主视图
  Widget _buildContent() {
    return Flexible(
      child: EasyRefresh(
        header: DeliveryHeader(),
        footer: PhoenixFooter(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: ScrollPhysics(),
          slivers: <Widget>[
            _buildTabs(),
            _buildSilverList(),
          ],
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(microseconds: 2000), () {
            _refreshData(_type);
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(milliseconds: 1500), () {
            _loadMore(_type);
          });
        },
      ),
    );
  }

  ///创建清理组件
  Widget _buildClear() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(Adaptor.width(16)),
        margin: EdgeInsets.only(
          top: Adaptor.width(16),
          bottom: Adaptor.width(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '一键清理',
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF4700),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Adaptor.width(6)),
                  child: Text(
                    '预测不稳定的专家，建议一键清理',
                    style: TextStyle(
                      fontSize: Adaptor.sp(13),
                      color: Color(0xFF666466),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: Adaptor.height(32),
                width: Adaptor.width(68),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Adaptor.height(16)),
                  color: Color(0xFFF6F6F6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '清理',
                      style: TextStyle(
                        color: Color(0xFFFF4600),
                        fontSize: Adaptor.sp(13),
                      ),
                    ),
                    Icon(
                      IconData(0xe602, fontFamily: 'iconfont'),
                      size: Adaptor.sp(15),
                      color: Color(0xFFFF4600),
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

  ///创建sticky header
  Widget _buildTabs() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: Adaptor.height(148),
        maxHeight: Adaptor.height(148),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.10),
                width: Adaptor.width(0.4),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: Adaptor.width(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  bottom: Adaptor.width(16),
                ),
                child: VipNavigator(),
              ),
              _buildTab(),
            ],
          ),
        ),
      ),
    );
  }

  ///创建标题
  Widget _buildTabTitle(String name) {
    TextStyle style =
        new TextStyle(color: Color(0xfff6ab72), fontSize: Adaptor.sp(13));
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(5), 0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfff8f8f8),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: Adaptor.height(26),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(
            Adaptor.width(10),
            Adaptor.width(2),
            Adaptor.width(10),
            Adaptor.width(2),
          ),
          child: Text(
            name,
            style: style,
          ),
        ),
      ),
    );
  }

  ///创建tab选项卡
  Widget _buildTab() {
    return Container(
      height: Adaptor.height(26),
      padding: EdgeInsets.only(left: Adaptor.width(15)),
      child: Row(
        children: <Widget>[
          _buildTabTitle('类型'),
          Expanded(
            child: ListView(
              controller: _controller,
              padding: EdgeInsets.fromLTRB(
                  Adaptor.width(10), 0, Adaptor.width(15), 0),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                _buildItem('福彩3D', 'fc3d', 0),
                _buildItem('排列三', 'pl3', 0),
                _buildItem('双色球', 'ssq', 0),
                _buildItem('大乐透', 'dlt', 0),
                _buildItem('七乐彩', 'qlc', 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///创建选项
  Widget _buildItem(String name, String index, double margin) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(margin, 0, Adaptor.width(12), 0),
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: _type == index ? Color(0xfff1f1f1) : Color(0xfff8f8f8),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: InkWell(
            onTap: () {
              if (_type != index) {
                setState(() {
                  _type = index;
                });
                _initLoad(_type);
              }
            },
            child: Container(
              height: Adaptor.height(26),
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(10),
                Adaptor.width(2),
                Adaptor.width(10),
                Adaptor.width(2),
              ),
              child: Text(
                name,
                style: TextStyle(
                    fontSize: Adaptor.sp(13),
                    color: _type == index ? Color(0xffF43F3B) : Colors.black54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///创建master list信息
  Widget _buildSilverList() {
    if (!this.loading) {
      if (_error) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Constant.error('出错啦，点击重试', () {
            setState(() {
              loading = true;
            });
            _loadData(type: _type);
          }),
        );
      }
      SubscribeModel model = subscribes[_type];
      if (model != null && model.data != null && model.data.length > 0) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _itemView(context, index, model.data);
            },
            childCount: model.data.length,
          ),
        );
      }
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EmptyView(
                icon: 'assets/images/empty.png',
                message: '没有收藏记录',
                size: 98,
                margin: EdgeInsets.only(top: 0),
                callback: () {},
              ),
            ],
          ),
        ),
      );
    }
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      ),
    );
  }

  Widget _itemView(BuildContext context, int index, List masters) {
    var master = masters[index];
    return Container(
      decoration: index != masters.length - 1
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xfff1f1f1), width: 0.5),
              ),
            )
          : null,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
              0,
              Adaptor.width(0.5),
              0,
              Adaptor.width(0.5),
            ),
            child: IconSlideAction(
              caption: '删除',
              color: Colors.redAccent,
              iconWidget: Padding(
                padding: EdgeInsets.only(bottom: Adaptor.width(2)),
                child: Icon(
                  IconData(0xe61c, fontFamily: 'iconfont'),
                  size: Adaptor.sp(20),
                  color: Colors.white,
                ),
              ),
              onTap: () {
                _cancelSubscribe(
                  masters,
                  index,
                  master['masterId'],
                  master['type'],
                );
              },
            ),
          ),
        ],
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Widget page;
                    switch (master['type']) {
                      case 'fc3d':
                        page = Fc3dMasterPage(master['masterId'], index: 6);
                        break;
                      case 'pl3':
                        page = Pl3MasterPage(master['masterId'], index: 6);
                        break;
                      case 'ssq':
                        page = SsqMasterPage(master['masterId'], index: 1);
                        break;
                      case 'dlt':
                        page = DltMasterPage(master['masterId'], index: 1);
                        break;
                      case 'qlc':
                        page = QlcMasterPage(master['masterId']);
                        break;
                    }
                    AppNavigator.push(context, page, login: true);
                  },
                  child: Container(
                    padding: EdgeInsets.all(Adaptor.width(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: Adaptor.width(42),
                          height: Adaptor.height(42),
                          margin: EdgeInsets.symmetric(
                            horizontal: Adaptor.width(10),
                          ),
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            width: Adaptor.width(42),
                            height: Adaptor.height(42),
                            fit: BoxFit.cover,
                            imageUrl: master['image'],
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(bottom: Adaptor.width(8)),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  Tools.limitName(master['name'], 9),
                                  style: TextStyle(
                                    color: Color(0xff5c5c5c),
                                    fontSize: Adaptor.sp(13),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: _getRate(master),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 28,
                margin: EdgeInsets.only(bottom: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _buildRate(master['rate1Name'], master['rateHit1'], 10),
                    _buildRate(master['rate2Name'], master['rateHit2'], 0),
                    _buildRate(master['rate3Name'], master['rateHit3'], 0),
                    _buildRate(master['rate4Name'], master['rateHit4'], 0),
                    _buildRate(master['rate5Name'], master['rateHit5'], 0),
                    _buildRate(master['rate6Name'], master['rateHit6'], 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getRate(var item) {
    List<Widget> views = <Widget>[];
    if (item['rate1'] >= 0.75) {
      views.add(
        MarkView(
          name: item['rate1Name'],
        ),
      );
    }
    if (item['rate3'] >= 0.8) {
      views.add(
        MarkView(
          name: item['rate3Name'],
        ),
      );
    }
    if (item['rate5'] >= 0.8) {
      views.add(
        MarkView(
          name: item['rate5Name'],
        ),
      );
    }
    if (views.length == 0) {
      views.add(MarkView(
        name: '加油中',
      ));
    }
    return views;
  }

  Widget _buildRate(String name, String hit, double margin) {
    return Container(
      margin: EdgeInsets.fromLTRB(margin, 0, Adaptor.width(12), 0),
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(8),
        0,
        Adaptor.width(8),
        0,
      ),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Adaptor.width(3.0)),
      ),
      child: Row(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              color: Colors.black54,
              fontSize: Adaptor.sp(12),
            ),
          ),
          Text(
            hit,
            style: TextStyle(
              color: Color(0xFFFF512F),
              fontSize: Adaptor.sp(12),
            ),
          )
        ],
      ),
    );
  }

  ///初始化
  void _initLoad(String type) {
    SubscribeModel model = subscribes[type];
    if (model == null) {
      _loadData(type: type);
    }
  }

  ///取消订阅
  ///
  void _cancelSubscribe(
    List masters,
    int index,
    String masterId,
    String type,
  ) {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['type'] = type;
    params['masterId'] = masterId;
    request.getJson('/subscribe/cancel', params: params).then((response) {
      var data = response.data;
      if (data['status'] == 200) {
        EasyLoading.showToast('取消成功');
        setState(() {
          masters.removeAt(index);

          ///如果当前数据全部删除完成
          ///重新加载数据
          if (masters.length == 0) {
            SubscribeModel model = subscribes[type];
            model.page = 1;

            ///加载数据
            _loadData(type: type, page: model.page);
          }
        });
        return;
      }
      EasyLoading.showToast(data['message']);
    }).catchError((error) {
      EasyLoading.showToast('取消失败');
    });
  }

  ///加载数据
  ///
  void _loadData({String type = 'fc3d', int page = 1, int limit = 8}) {
    setState(() {
      loading = true;
    });
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['page'] = page;
    params['limit'] = limit;
    request
        .getJson('/subscribe/' + type + '/masters', params: params)
        .then((response) {
      var data = response.data['data'];
      print(data);
      List masters = data['data'] != null ? data['data'] : List();
      setState(() {
        SubscribeModel model = subscribes[type];
        if (model == null) {
          model = new SubscribeModel(masters, type, page);
          subscribes[type] = model;
        } else {
          model.data.clear();
          model.data.addAll(masters);
          model.page = page;
        }
        loading = false;
        _error = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        loading = false;
        _error = true;
      });
    });
  }

  ///刷新数据
  void _refreshData(String type) {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['page'] = 1;
    params['limit'] = 8;
    request
        .getJson('/subscribe/' + type + '/masters', params: params)
        .then((response) {
      var data = response.data['data'];
      List masters = data['data'] != null ? data['data'] : List();
      setState(() {
        SubscribeModel model = subscribes[type];
        if (model == null) {
          model = new SubscribeModel(masters, type, 1);
          subscribes[type] = model;
        } else {
          model.data.clear();
          model.data.addAll(masters);
          model.page = 1;
        }
        _error = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        _error = true;
      });
    });
  }

  ///加载更多
  void _loadMore(String type) async {
    SubscribeModel model = subscribes[type];
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    int page = model.page;
    params['page'] = ++page;
    params['limit'] = _limit;
    request
        .getJson('/subscribe/' + type + '/masters', params: params)
        .then((response) {
      var data = response.data['data'];
      List masters = data['data'] != null ? data['data'] : List();
      setState(() {
        model.data.addAll(masters);
        model.page = page;
        _error = false;
      });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class SubscribeModel {
  ///数据
  List data = List();

  ///数据类型
  String type;

  ///分页页码
  int page;

  SubscribeModel(this.data, this.type, this.page);
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;

  final double maxHeight;

  final Widget child;

  _SliverAppBarDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent ||
        child != oldDelegate.child;
  }

  @override
  double get maxExtent {
    return maxHeight;
  }

  @override
  double get minExtent {
    return minHeight;
  }
}
