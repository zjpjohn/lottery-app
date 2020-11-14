import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/components/tag_mark.dart';
import 'package:lottery_app/master/dlt-master.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/custome_card.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';

class DltGladPage extends StatefulWidget {
  @override
  DltGladPageState createState() => new DltGladPageState();
}

class DltGladPageState extends State<DltGladPage> {
  //开奖数据
  List _glads = new List();

  //分页页码
  int _page = 1;

  //每页数据
  int _limit = 8;

  //是否加载
  bool _loaded = false;

  ///加载错误
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          MAppBar('预测中奖专家'),
          Expanded(child: _buildList(context))
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
            padding: EdgeInsets.only(
              top: Adaptor.width(12),
            ),
            itemCount: _glads.length,
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
    var item = this._glads[index];
    return _gladView(item);
  }

  Widget _gladView(var item) {
    return new Container(
      margin: EdgeInsets.fromLTRB(
        Adaptor.width(12),
        0,
        Adaptor.width(12),
        Adaptor.width(12),
      ),
      child: new CCard(
        child: new Container(
          alignment: Alignment.center,
          child: new InkWell(
            onTap: () {
              AppNavigator.push(
                context,
                DltMasterPage(
                  item['masterId'],
                  index: 1,
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
                    Adaptor.width(14),
                    0,
                    Adaptor.width(14),
                    0,
                  ),
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
                      0,
                      Adaptor.width(10),
                      Adaptor.width(10),
                      Adaptor.width(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(bottom: Adaptor.width(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                Tools.limitName(item['name'], 9),
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
                          margin: EdgeInsets.only(
                            bottom: Adaptor.width(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _getRate(item),
                          ),
                        ),
                        new Container(
                          child: Row(
                            children: <Widget>[
                              new Container(
                                margin:
                                    EdgeInsets.only(right: Adaptor.width(5)),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '红球大底',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    ),
                                    Text(
                                      item['red20'],
                                      style: TextStyle(
                                        color: Color(0xffF43F3B),
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new Container(
                                margin:
                                    EdgeInsets.only(right: Adaptor.width(5)),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '蓝球',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    ),
                                    Text(
                                      item['blue6'],
                                      style: TextStyle(
                                        color: Color(0xffF43F3B),
                                        fontSize: Adaptor.sp(13),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  flex: 3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getRate(var item) {
    List<Widget> views = <Widget>[];
    if (item['red20Rate'] >= 0.5) {
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
    if (views.length == 0) {
      views.add(MarkView(
        name: '加油中',
      ));
    }
    return views;
  }

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = new Map();
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/dlt/glad', params: params).then((response) {
      var data = response.data['data'];
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            this._glads.clear();
            this._glads.addAll(data['data']);
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
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/dlt/glad', params: params).then((response) {
      var data = response.data['data'];
      setState(() {
        this._glads.clear();
        this._glads.addAll(data['data']);
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
    params['page'] = this._page;
    params['limit'] = _limit;
    request.getJson('/dlt/glad', params: params).then((response) {
      var data = response.data['data'];
      setState(() {
        this._glads.addAll(data['data']);
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
