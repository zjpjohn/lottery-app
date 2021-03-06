import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:lottery_app/components/forecast_card.dart';
import 'package:lottery_app/list/ssq-list.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/master/ssq-master.dart';
import 'package:lottery_app/components/adaptor.dart';

class SsqForecastPage extends StatefulWidget {
  @override
  SsqForecastPageState createState() => new SsqForecastPageState();
}

class SsqForecastPageState extends State<SsqForecastPage>
    with AutomaticKeepAliveClientMixin {
  //独胆专家
  List _dan1s = new List();

  //双胆专家
  List _dan2s = new List();

  //三胆专家
  List _dan3s = new List();

  //12码专家
  List _red12s = new List();

  //20码专家
  List _red20s = new List();

  //25码专家
  List _red25s = new List();

  //杀三码专家
  List _kill3s = new List();

  //杀六码专家
  List _kill6s = new List();

  //蓝球三码专家
  List _blue3s = new List();

//蓝球五码专家
  List _blue5s = new List();

//蓝球杀码专家
  List _bkills = new List();

  bool _loaded = false;

  bool _error = false;

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
      return Center(
        child: Container(
          color: Color(0xFFF8F8F8),
          child: EasyRefresh(
            header: DeliveryHeader(),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: 11,
              itemBuilder: (BuildContext context, int index) {
                return _itemView(context, index);
              },
            ),
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 3), () {
                _refresh();
              });
            },
          ),
        ),
      );
    } else {
      return new Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      );
    }
  }

  List<Widget> _itemsWidget(
      String title, int index, List data, List<Color> colors) {
    List<Widget> views = new List();
    views.add(new Container(
      height: Adaptor.height(36),
      padding: EdgeInsets.fromLTRB(Adaptor.width(16), 0, Adaptor.width(16), 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: colors,
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: Adaptor.width(6)),
                      child: Icon(
                        IconData(0xe647, fontFamily: 'iconfont'),
                        size: Adaptor.sp(16),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adaptor.sp(16),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, SsqLitPage(index, title), login: true);
            },
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '更多专家',
                    style: TextStyle(
                      fontSize: Adaptor.sp(13),
                      height: 1.1,
                      color: Color(0xffFF512F),
                    ),
                  ),
                  Icon(
                    IconData(0xe602, fontFamily: 'iconfont'),
                    size: Adaptor.sp(13),
                    color: Color(0xffFF512F),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
    List<Widget> masters = [];
    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      Widget view = ForecastCard(
        name: item['name'],
        rate: item['rateStr'],
        series: item['series'],
        margin: EdgeInsets.fromLTRB(0, 0, 0, Adaptor.width(14)),
        page: SsqMasterPage(
          item['masterId'],
          index: index <= 9 ? 1 : 2,
        ),
      );
      masters.add(view);
    }
    Widget masterView = Container(
      margin: EdgeInsets.fromLTRB(0, Adaptor.width(10), 0, Adaptor.width(4)),
      child: Wrap(
        spacing: Adaptor.width(16),
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: masters,
      ),
    );
    views.add(masterView);
    return views;
  }

  Widget _itemView(BuildContext context, int index) {
    if (index + 1 == 1) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('独胆', 1, _dan1s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 2) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('双胆', 2, _dan2s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 3) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('三胆', 3, _dan3s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 4) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('红球12码', 4, _red12s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 5) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('红球20码', 5, _red20s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 6) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('红球25码', 6, _red25s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 7) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('杀三码', 7, _kill3s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 8) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('杀六码', 8, _kill6s, [
            Color(0xeFFFF4600),
            Color(0xeFFFF4600),
          ]),
        ),
      );
    }
    if (index + 1 == 9) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('蓝球三码', 9, _blue3s, [
            Color(0xeFF3376F6),
            Color(0xeFF3376F6),
          ]),
        ),
      );
    }
    if (index + 1 == 10) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('蓝球五码', 10, _blue5s, [
            Color(0xeFF3376F6),
            Color(0xeFF3376F6),
          ]),
        ),
      );
    }
    if (index + 1 == 11) {
      return new Container(
        width: double.infinity,
        child: Column(
          children: _itemsWidget('蓝球杀码', 11, _bkills, [
            Color(0xeFF3376F6),
            Color(0xeFF3376F6),
          ]),
        ),
      );
    }
  }

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    request.getJson('/hmaster/ssq').then((response) {
      final data = response.data['data'];
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            this._dan1s = data['1'];
            this._dan2s = data['2'];
            this._dan3s = data['3'];
            this._red12s = data['4'];
            this._red20s = data['5'];
            this._red25s = data['6'];
            this._kill3s = data['7'];
            this._kill6s = data['8'];
            this._blue3s = data['9'];
            this._blue5s = data['10'];
            this._bkills = data['11'];
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
    request.getJson('/hmaster/ssq').then((response) {
      var data = response.data['data'];
      setState(() {
        this._dan1s = data['1'];
        this._dan2s = data['2'];
        this._dan3s = data['3'];
        this._red12s = data['4'];
        this._red20s = data['5'];
        this._red25s = data['6'];
        this._kill3s = data['7'];
        this._kill6s = data['8'];
        this._blue3s = data['9'];
        this._blue5s = data['10'];
        this._bkills = data['11'];
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
