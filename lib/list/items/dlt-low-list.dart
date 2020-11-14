import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/components/tag_mark.dart';
import 'package:lottery_app/master/dlt-master.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/adaptor.dart';

class DltLowList extends StatefulWidget {
  int _type;

  DltLowList(this._type);

  @override
  DltLowListState createState() => new DltLowListState();
}

class DltLowListState extends State<DltLowList>
    with AutomaticKeepAliveClientMixin {
  int _page = 1;

  int _limit = 8;

  bool _loaded = false;

  bool _error = false;

  List _masters = new List();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            itemCount: _masters.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildView(context, index);
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

  Widget _buildView(BuildContext context, int index) {
    var item = _masters[index];
    return Container(
      padding: EdgeInsets.only(
          left: Adaptor.width(16),
          right: Adaptor.width(16),
          top: Adaptor.width(8),
          bottom: Adaptor.width(8)),
      height: Adaptor.height(88),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: Adaptor.height(0.2),
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          AppNavigator.push(
            context,
            DltMasterPage(
              item['masterId'],
              index: widget._type < 8 ? 1 : 2,
            ),
            login: true,
          );
        },
        child: Row(
          children: <Widget>[
            Container(
              width: Adaptor.width(58),
              height: Adaptor.height(58),
              margin: EdgeInsets.fromLTRB(0, 0, Adaptor.width(16), 0),
              alignment: Alignment.center,
              child: CachedNetworkImage(
                width: Adaptor.width(58),
                height: Adaptor.height(58),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: Adaptor.width(4)),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: Adaptor.width(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _getRate(item),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.only(right: Adaptor.width(8)),
                          child: Text(
                            item['rate'],
                            style: TextStyle(
                                color: Color(0xFFFF512F),
                                fontSize: Adaptor.sp(14)),
                          )),
                      new Container(
                        margin: EdgeInsets.only(right: Adaptor.width(5)),
                        child: _getSeriesView(item['series']),
                      )
                    ],
                  ),
                ],
              ),
              flex: 3,
            )
          ],
        ),
      ),
    );
  }

  Widget _getSeriesView(int series) {
    if (series > 0) {
      return Text(
        '连中' + series.toString() + '期',
        style: TextStyle(color: Color(0xFFFF512F), fontSize: Adaptor.sp(14)),
      );
    }
    return Text(
      '上期未中',
      style: TextStyle(color: Colors.black38, fontSize: Adaptor.sp(14)),
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
    if (item['bkillRate'] >= 0.8) {
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
    _page = 1;
    params['type'] = widget._type;
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/dlt/free/ranks', params: params).then((response) {
      var data = response.data['data'];
      if (response.data['status'] != 200) {
        setState(() {
          _error = true;
          _loaded = true;
        });
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            this._masters.clear();
            this._masters.addAll(data['data']);
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
    params['type'] = widget._type;
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/dlt/free/ranks', params: params).then((response) {
      var data = response.data['data'];
      setState(() {
        this._masters.clear();
        this._masters.addAll(data['data']);
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
    params['type'] = widget._type;
    params['page'] = this._page;
    params['limit'] = _limit;
    request.getJson('/dlt/free/ranks', params: params).then((response) {
      var data = response.data['data'];
      setState(() {
        this._masters.addAll(data['data']);
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
