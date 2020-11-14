import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/components/tag_mark.dart';
import 'package:lottery_app/master/ssq-master.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';

class SsqRanksPage extends StatefulWidget {
  ///排行榜类型
  ///
  int type;

  SsqRanksPage(this.type);

  @override
  SsqRanksPageState createState() => new SsqRanksPageState();
}

class SsqRanksPageState extends State<SsqRanksPage> {
  //是否加载完成
  bool _loaded = false;

  //是否数据为空
  bool _isNull = false;

  ///加载是否出错
  bool _error = false;

  //专家数据
  List _masters = List();

  int _page = 1;

  int _limit = 8;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          MAppBar('专家排行榜'),
          _buildRanks(context),
        ],
      ),
    );
  }

  Widget _buildRanks(BuildContext context) {
    if (this._loaded) {
      if (_error) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                setState(() {
                  _loaded = false;
                });
                _loadData();
              })
            ],
          ),
        );
      }
      return new Expanded(
        child: new EasyRefresh(
          header: DeliveryHeader(),
          footer: PhoenixFooter(),
          child: ListView.builder(
            itemCount: _masters.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemView(context, index);
            },
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 3), () {
              _refresh();
            });
          },
          onLoad: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              _loadMore();
            });
          },
        ),
      );
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Constant.loading(),
        ],
      ),
    );
  }

  Widget _itemView(BuildContext context, int index) {
    var master = _masters[index];
    return Container(
      height: Adaptor.height(112),
      padding:
          EdgeInsets.only(top: Adaptor.width(12), bottom: Adaptor.width(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: Adaptor.height(0.2),
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: Adaptor.width(16), right: Adaptor.width(16)),
            margin: EdgeInsets.only(bottom: Adaptor.width(8)),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                AppNavigator.push(
                  context,
                  SsqMasterPage(
                    master['masterId'],
                    index: widget.type == 0 ? 1 : 2,
                  ),
                  login: true,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: Adaptor.width(44),
                    height: Adaptor.height(44),
                    margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(10), 0),
                    child: CachedNetworkImage(
                      width: Adaptor.width(44),
                      height: Adaptor.height(44),
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: Adaptor.width(8)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Tools.limitName(master['name'], 8),
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: Adaptor.sp(16),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _getRate(master),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Adaptor.width(10), 0, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: Adaptor.width(6)),
                          child: Text(
                            '综合排名',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: Adaptor.sp(13),
                            ),
                          ),
                        ),
                        Text(
                          "${master['rank']}",
                          style: TextStyle(
                            color: Color(0xFFFF512F),
                            fontSize: Adaptor.sp(20),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: Adaptor.height(26),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: widget.type != 1
                  ? <Widget>[
                      _buildRate('三胆', master['red3'], Adaptor.width(16)),
                      _buildRate('12码', master['red12'], 0),
                      _buildRate('20码', master['red20'], 0),
                      _buildRate('25码', master['red25'], 0),
                      _buildRate('杀三', master['kill3'], 0),
                      _buildRate('蓝五', master['blue5'], 0),
                      _buildRate('杀蓝', master['blueKill'], 0),
                    ]
                  : <Widget>[
                      _buildRate('杀蓝', master['blueKill'], Adaptor.width(16)),
                      _buildRate('蓝五', master['blue5'], 0),
                      _buildRate('25码', master['red25'], 0),
                      _buildRate('20码', master['red20'], 0),
                      _buildRate('杀三', master['kill3'], 0),
                      _buildRate('12码', master['red12'], 0),
                      _buildRate('三胆', master['red3'], 0),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getRate(var item) {
    List<Widget> views = <Widget>[];
    views.add(
      new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: Adaptor.width(8)),
        padding: EdgeInsets.fromLTRB(
          Adaptor.width(6),
          Adaptor.width(1),
          Adaptor.width(6),
          Adaptor.width(1),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(2.0),
          color: Color(0xFFF6F6F6),
        ),
        child: Text(
          '擅长',
          style: TextStyle(
            fontSize: Adaptor.sp(10),
            color: Colors.black54,
          ),
        ),
      ),
    );
    if (item['red25Rate'] >= 0.5) {
      views.add(MarkView(
        name: '围红',
      ));
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
    return views;
  }

  Widget _buildRate(String name, String hit, double margin) {
    return new Container(
      margin: EdgeInsets.fromLTRB(margin, 0, Adaptor.width(12), 0),
      padding: EdgeInsets.fromLTRB(Adaptor.width(8), 0, Adaptor.width(8), 0),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Row(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.black54, fontSize: Adaptor.sp(12)),
          ),
          Text(
            hit,
            style:
                TextStyle(color: Color(0xFFFF512F), fontSize: Adaptor.sp(12)),
          )
        ],
      ),
    );
  }

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    _page = 1;
    params['type'] = widget.type;
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/ssq/top/masters', params: params).then((response) {
      var data = response.data['data'];
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _masters.clear();
            List masters = data['data'];
            if (masters == null || masters.length == 0) {
              _isNull = true;
            }
            _masters.addAll(masters);
            _loaded = true;
            _error = false;
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
    _page = 1;
    Map<String, dynamic> params = Map();
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/ssq/top/masters', params: params).then((response) {
      var data = response.data['data'];
      List masters = data['data'];
      setState(() {
        _masters.clear();
        if (masters == null || masters.length == 0) {
          _isNull = true;
        }
        _masters.addAll(masters);
        _error = false;
      });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
  }

  void _loadMore() {
    HttpRequest request = HttpRequest.instance();
    _page++;
    Map<String, dynamic> params = Map();
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/ssq/top/masters', params: params).then((response) {
      var data = response.data['data'];
      List masters = data['data'];
      setState(() {
        if (masters != null && masters.length > 0) {
          _masters.addAll(masters);
        }
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
    super.dispose();
  }
}
