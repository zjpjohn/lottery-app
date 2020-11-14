import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/fast_table.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/header_bar.dart';

class Fc3dTablePage extends StatefulWidget {
  @override
  Fc3dTablePageState createState() => new Fc3dTablePageState();
}

class Fc3dTablePageState extends State<Fc3dTablePage> {
  //是否加载
  bool _loaded = false;

  ///加载错误
  bool _error = false;

  //期号
  String _period;

  //上期试机号
  List _lastShi = List();

  //上期开奖号
  List _last = List();

  //本期试机号
  List _currShi = List();

  //本期开奖号
  List _current = List();

  //速查表渲染数据
  List<List<RenderResult>> _renders;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            MAppBar('速查表'),
            _buildTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    if (_loaded) {
      if (_error) {
        return Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Constant.error('出错啦，点击重试', () {
                setState(() {
                  _loaded = false;
                });
                _loadData();
              }),
            ],
          ),
        );
      }
      return Expanded(
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, Adaptor.width(10), 0, 0),
          physics: EasyRefreshPhysics(topBouncing: false),
          children: <Widget>[
            _buildTitle(),
            _buildBalls(),
            _renderTable(),
            HeaderBar(
              title: '使用说明',
              icon: 0xe648,
              height: 24,
              padding: EdgeInsets.only(
                left: Adaptor.width(16),
              ),
            ),
            _buildHelpInfo(),
          ],
        ),
      );
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Constant.loading(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, Adaptor.width(10), 0, Adaptor.width(15)),
      child: Text(
        '第$_period期福彩3D速查表',
        style: TextStyle(
          color: Colors.black87,
          fontSize: Adaptor.sp(18),
        ),
      ),
    );
  }

  Widget _buildBalls() {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(20)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: Adaptor.width(10)),
            child: Container(
              height: Adaptor.width(36),
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(14),
                0,
                Adaptor.width(10),
                0,
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/header.png',
                    height: Adaptor.height(16),
                  ),
                  Text(
                    '上期开奖',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.sp(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: Adaptor.width(10)),
            padding: EdgeInsets.fromLTRB(
              Adaptor.width(20),
              0,
              Adaptor.width(15),
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildBall(
                  '试机号',
                  _lastShi,
                  Color(0xffb0c8a5),
                  size: _currShi == null || _currShi.isEmpty ? 11 : 12,
                ),
                _buildBall(
                  '开奖号',
                  _last,
                  Color(0xffe4c4cd),
                  size: _last == null || _last.isEmpty ? 11 : 12,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: Adaptor.width(10)),
            child: Container(
              height: Adaptor.width(36),
              padding: EdgeInsets.fromLTRB(
                Adaptor.width(14),
                0,
                Adaptor.width(10),
                0,
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/header_sub.png',
                    height: Adaptor.height(16),
                  ),
                  Text(
                    '本期开奖',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Adaptor.sp(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              Adaptor.width(20),
              0,
              Adaptor.width(15),
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildBall(
                  '试机号',
                  _currShi,
                  Color(0xffbab0b0),
                  size: _currShi == null || _currShi.isEmpty ? 11 : 12,
                ),
                _buildBall(
                  '开奖号',
                  _current,
                  Color(0xffF48F7B),
                  size: _current == null || _current.isEmpty ? 11 : 12,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBall(String name, List balls, Color color, {double size: 12}) {
    List<Widget> views = List();
    List<String> items;
    if (balls == null || balls.isEmpty) {
      items = ['待', '开', '奖'];
    } else {
      items = List<String>.from(balls);
    }
    views.add(new Container(
      margin: EdgeInsets.only(right: Adaptor.width(5)),
      child: Text(
        name,
        style: TextStyle(color: Colors.black54, fontSize: Adaptor.width(14)),
      ),
    ));
    items.forEach((ball) {
      Widget view = new Container(
        width: Adaptor.width(22),
        height: Adaptor.width(22),
        margin: EdgeInsets.only(right: Adaptor.width(5)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Text(
          ball,
          style: TextStyle(
            color: Colors.white,
            fontSize: Adaptor.sp(size),
          ),
        ),
      );
      views.add(view);
    });
    return Container(
      margin: EdgeInsets.only(right: Adaptor.width(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: views,
      ),
    );
  }

  Widget _renderTable() {
    List<TableRow> rows = List();
    for (int i = 0; i < _renders.length; i++) {
      List<RenderResult> row = _renders[i];
      List<Widget> cells = List();
      for (int j = 0; j < row.length; j++) {
        RenderResult render = row[j];
        Widget cell = Container(
          height: Adaptor.width(22),
          width: Adaptor.width(22),
          alignment: Alignment.center,
          color: render.color,
          child: Text(
            render.key,
            style: TextStyle(
                color: Colors.black54,
                fontSize: Adaptor.sp(13),
                fontWeight: FontWeight.w600),
          ),
        );
        cells.add(cell);
      }
      TableRow tableRow = new TableRow(children: cells);
      rows.add(tableRow);
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(16),
        0,
        Adaptor.width(16),
        0,
      ),
      margin: EdgeInsets.only(bottom: Adaptor.width(8)),
      child: Table(
        defaultColumnWidth: FixedColumnWidth(22),
        border: TableBorder.all(
          width: Adaptor.width(0.2),
          color: Colors.black12,
        ),
        children: rows,
      ),
    );
  }

  Widget _buildHelpInfo() {
    return Container(
      padding: EdgeInsets.only(
        top: Adaptor.width(4),
        left: Adaptor.width(16),
        right: Adaptor.width(16),
        bottom: Adaptor.width(32),
      ),
      child: Text(
        '一般情况，今天的开奖号码很大可能在昨天开奖号码附近；'
        '尽可能地昨日开奖号码90度或45度附近寻找今天的开奖号码，'
        '同时参考今天的试机号，尽可能的缩小选号范围。准确使用速查表，'
        '需要不断观察，不断总结经验。',
        style: TextStyle(
          color: Colors.black38,
          fontSize: Adaptor.sp(12),
        ),
      ),
    );
  }

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['type'] = 'fucai_3d';
    request.getJson('/lottery/table', params: params).then((response) {
      var data = response.data['data'];
      var currInfo = data['current'];
      var lastInfo = data['last'];
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _period = currInfo['period'];
            _currShi = currInfo['shiBalls'];
            _current = currInfo['redBalls'];
            _lastShi = lastInfo['shiBalls'];
            _last = lastInfo['redBalls'];
            List<List<bool>> lastShiTable = FastTable.chkBall(_lastShi);
            List<List<bool>> lastTable = FastTable.chkBall(_last);
            List<List<bool>> currShiTable = FastTable.chkBall(_currShi);
            _renders =
                FastTable.renderTable(lastTable, lastShiTable, currShiTable);
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
