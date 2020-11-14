import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/browse_filter_view.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/master/fc3d-master.dart';
import 'package:lottery_app/master/pl3-master.dart';
import 'package:lottery_app/master/ssq-master.dart';
import 'package:lottery_app/master/dlt-master.dart';
import 'package:lottery_app/master/qlc-master.dart';
import 'package:lottery_app/commons/avatar.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/tools.dart';

class UserBrowsePage extends StatefulWidget {
  @override
  UserBrowsePageState createState() => new UserBrowsePageState();
}

class UserBrowsePageState extends State<UserBrowsePage> {
  ///是否加载完成
  bool _loaded = false;

  ///是否加载错误
  bool _error = false;

  String _type = 'fc3d';

  ///开始时间
  DateTime start;

  ///结束时间
  DateTime end;

  ///数据
  Map<String, BrowseModel> datas = {
    'fc3d': BrowseModel(1, List()),
    'pl3': BrowseModel(1, List()),
    'ssq': BrowseModel(1, List()),
    'dlt': BrowseModel(1, List()),
    'qlc': BrowseModel(1, List()),
  };

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            MAppBar('我的足迹'),
            Expanded(
              child: BrowseFilterView(
                onSelected: (value) {
                  setState(() {
                    _type = value.key;
                  });
                  _loadData(value.key);
                },
                init: FilterEntry('fc3d', '福彩三'),
                data: [
                  FilterEntry('fc3d', '福彩三'),
                  FilterEntry('pl3', '排列三'),
                  FilterEntry('ssq', '双色球'),
                  FilterEntry('dlt', '大乐透'),
                  FilterEntry('qlc', '七乐彩')
                ],
                dates: [
                  DateUtil.formatDate(start, format: 'yy/MM/dd'),
                  DateUtil.formatDate(end, format: 'yy/MM/dd'),
                ],
                child: _buildDataView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataView() {
    if (_loaded) {
      if (_error) {
        return Constant.error('出错啦，点击重试', () {
          setState(() {
            _loaded = true;
          });
          _loadData(_type);
        });
      }
      BrowseModel model = datas[_type];
      if (model.data.length > 0) {
        return EasyRefresh(
          header: DeliveryHeader(),
          footer: PhoenixFooter(),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 0),
            itemCount: model.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemView(context, index, model.data);
            },
          ),
          onRefresh: () async {
            refreshData(_type);
          },
          onLoad: () async {
            loadMore(_type);
          },
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'img/no-data.png',
            height: 100,
            width: 120,
            fit: BoxFit.contain,
          ),
          Text(
            '没有浏览记录',
            style: TextStyle(color: Colors.black26, fontSize: 14),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Constant.loading(),
      ],
    );
  }

  Widget _itemView(BuildContext context, int index, List masters) {
    var master = masters[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: index != masters.length
            ? Border(
                bottom: BorderSide(color: Color(0xfff2f2f2), width: 0.5),
              )
            : null,
      ),
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
                padding: EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: Alignment.center,
                      child: new Avatar(
                        master['name'],
                        fontSize: 24,
                        size: 42,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Tools.limitName(master['name'], 9),
                              style: TextStyle(
                                  color: Color(0xff5c5c5c), fontSize: 13),
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
            margin: EdgeInsets.only(bottom: 10),
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
    );
  }

  List<Widget> _getRate(var item) {
    List<Widget> views = <Widget>[];
    views.add(new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 5),
      child: Text(
        '擅长',
        style: TextStyle(color: Color(0xff5c5c5c), fontSize: 13),
      ),
    ));
    if (item['rate1'] >= 0.75) {
      Widget view = new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xFFFF512F)),
        child: Text(
          item['rate1Name'],
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      );
      views.add(view);
    }
    if (item['rate3'] >= 0.8) {
      Widget view = new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xFFFF512F)),
        child: Text(
          item['rate3Name'],
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      );
      views.add(view);
    }
    if (item['rate5'] >= 0.8) {
      Widget view = new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xFFFF512F)),
        child: Text(
          item['rate5Name'],
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      );
      views.add(view);
    }
    return views;
  }

  Widget _buildRate(String name, String hit, double margin) {
    return Container(
      margin: EdgeInsets.fromLTRB(margin, 0, 8, 0),
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Text(
            hit,
            style: TextStyle(color: Color(0xFFFF512F), fontSize: 12),
          )
        ],
      ),
    );
  }

  void _loadData(String type) {
    BrowseModel model = datas[type];
    if (model.data.length > 0) {
      setState(() {
        _type = type;
      });
      return;
    }
    setState(() {
      _loaded = false;
    });
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['page'] = 1;
    params['limit'] = 8;
    params['type'] = type;

    request.getJson('/user/browse', params: params).then((response) {
      var data = response.data['data'];
      List masters = data['data'] != null ? data['data'] : List();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) {
          return;
        }
        setState(() {
          BrowseModel model = datas[type];
          model.page = 1;
          model.data.clear();
          model.data.addAll(masters);
          _loaded = true;
          _error = false;
        });
      });
    }).catchError((error) {
      setState(() {
        _loaded = true;
        _error = true;
      });
    });
  }

  void loadMore(String type) {
    BrowseModel model = datas[type];
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    int page = model.page;
    params['page'] = ++page;
    params['limit'] = 8;
    params['type'] = type;
    request.getJson('/user/browse', params: params).then((response) {
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

  void refreshData(String type) {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['page'] = 1;
    params['limit'] = 8;
    params['type'] = type;
    request.getJson('/user/browse', params: params).then((response) {
      var data = response.data['data'];
      List masters = data['data'] != null ? data['data'] : List();
      setState(() {
        BrowseModel model = datas[type];
        model.page = 1;
        model.data.clear();
        model.data.addAll(masters);
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
    end = DateTime.now();
    start = end.add(Duration(days: -6));
    _loadData('fc3d');
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BrowseModel {
  int page;

  List data;

  BrowseModel(this.page, this.data);
}
