import 'package:flutter/material.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_card.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/ball_view.dart';

class DltLotteryHistory extends StatefulWidget {
  @override
  DltLotteryHistoryState createState() => new DltLotteryHistoryState();
}

class DltLotteryHistoryState extends State<DltLotteryHistory> {
  //开奖数据
  List _lotteries = new List();

  //分页页码
  int _page = 1;

  //每页数据
  int _limit = 10;

  //是否加载
  bool _loaded = false;

  ///加载错误
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          MAppBar('历史开奖'),
          new Expanded(
            child: _buildList(context),
          )
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    if (this._loaded) {
      if (_error) {
        return Constant.error('出错啦，点击重试', () {
          setState(() {
            _loaded = false;
          });
          _loadData();
        });
      }
      return new Center(
        child: new EasyRefresh(
          header: DeliveryHeader(),
          footer: PhoenixFooter(),
          child: ListView.builder(
            padding: EdgeInsets.only(top: Adaptor.width(12)),
            itemCount: _lotteries.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemView(context, index);
            },
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 2000), () {
              _refresh();
            });
          },
          onLoad: () async {
            await Future.delayed(const Duration(milliseconds: 1500), () {
              _loadMore();
            });
          },
        ),
      );
    } else {
      return new Center(
        child: Container(
          child: Constant.loading(),
        ),
      );
    }
  }

  Widget _itemView(BuildContext context, int index) {
    var item = _lotteries[index];
    return new Container(
      margin: EdgeInsets.fromLTRB(
          Adaptor.width(12), 0, Adaptor.width(12), Adaptor.width(12)),
      child: new CCard(
        child: Container(
          padding: EdgeInsets.fromLTRB(Adaptor.width(12), Adaptor.width(12),
              Adaptor.width(12), Adaptor.width(12)),
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(bottom: Adaptor.width(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: Adaptor.width(10)),
                              child: Text(
                                '大乐透',
                                style: TextStyle(
                                    color: Color(0xFF5C5C5C),
                                    fontSize: Adaptor.sp(16),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              child: Text(
                                item['period'] + '期',
                                style: TextStyle(
                                    fontSize: Adaptor.sp(14),
                                    color: Color(0xff5c5c5c)),
                              ),
                            )
                          ],
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: new Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          item['openTime'] != null
                              ? item['openTime'] + '开奖'
                              : '',
                          style: TextStyle(
                              color: Color(0xff9c9c9c),
                              fontSize: Adaptor.sp(14)),
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
              new Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              _ballView(item['redBalls'], item['blueBalls']),
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = new Map();
    params['type'] = 'da_le_tou';
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/lottery/list', params: params).then((response) {
      var data = response.data['data'];
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            this._lotteries.clear();
            this._lotteries.addAll(data['data']);
            this._loaded = true;
            this._error = false;
          });
        }
      });
    }).catchError((error) {
      setState(() {
        _loaded = true;
        _error = true;
      });
    });
  }

  void _refresh() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = new Map();
    this._page = 1;
    params['type'] = 'da_le_tou';
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/lottery/list', params: params).then((response) {
      var data = response.data['data'];
      setState(() {
        this._lotteries.clear();
        this._lotteries.addAll(data['data']);
        this._error = false;
      });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
  }

  void _loadMore() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = new Map();
    this._page++;
    params['type'] = 'da_le_tou';
    params['page'] = this._page;
    params['limit'] = _limit;
    request.getJson('/lottery/list', params: params).then((response) {
      var data = response.data['data'];
      setState(() {
        this._lotteries.addAll(data['data']);
        this._error = false;
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
    super.dispose();
  }
}
