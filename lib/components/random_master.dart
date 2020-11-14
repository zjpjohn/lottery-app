import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/master/dlt-master.dart';
import 'package:lottery_app/master/fc3d-master.dart';
import 'package:lottery_app/master/pl3-master.dart';
import 'package:lottery_app/master/qlc-master.dart';
import 'package:lottery_app/master/ssq-master.dart';
import 'package:lottery_app/components/adaptor.dart';

class RandomMasterWidget extends StatefulWidget {
  ///专家类型
  ///
  String type;

  ///标题
  ///
  String title;

  ///回调方法
  ///
  Function callback;

  RandomMasterWidget({
    @required this.type,
    @required this.title,
    @required this.callback,
  });

  @override
  RandomMasterWidgetState createState() => new RandomMasterWidgetState();
}

class RandomMasterWidgetState extends State<RandomMasterWidget> {
  ///专家集合
  ///
  List masters = List();

  ///是否加载完成
  ///
  bool _loaded = false;

  ///是否加载错误
  ///
  bool _error = false;

  ///当前类型
  ///
  String current;

  ///展示个数
  ///
  int limit = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x04000000),
            offset: Offset(1.5, 3.0),
            blurRadius: 5.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                  Adaptor.width(6),
                  0,
                  Adaptor.width(6),
                  0,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.title}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adaptor.sp(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Adaptor.width(15), 0, 0, Adaptor.width(1.5)),
                      child: Text(
                        '优质专家推荐',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: Adaptor.sp(11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (context, state) {
                            return Center(
                              child: Container(
                                width: Adaptor.width(240),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(3)),
                                padding: EdgeInsets.all(Adaptor.width(10)),
                                child: Wrap(
                                  children: <Widget>[
                                    _buildTypeItem('fc3d', '福彩3D', state),
                                    _buildTypeItem('pl3', '排列三', state),
                                    _buildTypeItem('ssq', '双色球', state),
                                    _buildTypeItem('dlt', '大乐透', state),
                                    _buildTypeItem('qlc', '七乐彩', state),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    Adaptor.width(12),
                    Adaptor.width(8),
                    Adaptor.width(12),
                    Adaptor.width(8),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    size: Adaptor.sp(22),
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: Adaptor.height(240),
            padding: EdgeInsets.only(bottom: Adaptor.width(4)),
            child: _buildContent(),
          )
        ],
      ),
    );
  }

  Widget _buildTypeItem(String type, String name, StateSetter state) {
    return GestureDetector(
      onTap: () {
        if (current != type) {
          state(() {
            current = type;
          });
          widget.callback(type);
          _loadData();
        }
      },
      child: Container(
        width: Adaptor.width(100),
        height: Adaptor.height(30),
        margin: EdgeInsets.all(5),
        color: Color(0xfff5f5f5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: Adaptor.width(10)),
              child: Text(
                '$name',
                style: TextStyle(
                  fontSize: Adaptor.sp(15),
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  color: type == current ? Colors.redAccent : Colors.black54,
                ),
              ),
            ),
            type == current
                ? Padding(
                    padding: EdgeInsets.only(right: Adaptor.width(6)),
                    child: Icon(
                      IconData(0xe646, fontFamily: 'iconfont'),
                      size: Adaptor.sp(15),
                      color: Colors.redAccent,
                    ),
                  )
                : Offstage(
                    child: null,
                  ),
          ],
        ),
      ),
    );
  }

  ///构建内容显示信息
  ///
  Widget _buildContent() {
    if (_loaded) {
      if (_error) {
        return Constant.error('点击重试', () {
          setState(() {
            _loaded = false;
          });
          _loadData();
        });
      }
      if (masters.length == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EmptyView(
              icon: 'assets/images/empty.png',
              message: '没有预测专家',
              size: Adaptor.width(64),
              margin: EdgeInsets.only(top: 0),
              callback: () {
                setState(() {
                  _loaded = false;
                });
                _loadData();
              },
            ),
          ],
        );
      }
      return _mastersView();
    }
    return _skeleton();
  }

  ///默认骨架图
  ///
  Widget _skeleton() {
    List<Widget> skeletons = List();
    for (int i = 0; i < limit; i++) {
      skeletons.add(
        Container(
          margin: EdgeInsets.fromLTRB(
            Adaptor.width(7),
            Adaptor.width(4),
            Adaptor.width(7),
            Adaptor.width(4),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(Adaptor.width(4)),
                width: Adaptor.width(60),
                height: Adaptor.height(60),
                color: Color(0xfffbfbfb),
                child: null,
              ),
              Container(
                width: Adaptor.width(60),
                color: Color(0xfffbfbfb),
                child: Text(
                  ' ',
                  style: TextStyle(fontSize: Adaptor.sp(14)),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          Wrap(
            children: skeletons,
          ),
          Container(
            height: Adaptor.height(36),
            margin: EdgeInsets.fromLTRB(Adaptor.width(15), Adaptor.width(7),
                Adaptor.width(15), Adaptor.width(4)),
            color: Color(0xfffbfbfb),
            child: null,
          ),
        ],
      ),
    );
  }

  ///构建master信息
  ///
  Widget _mastersView() {
    List<Widget> views = masters.map((master) {
      return InkWell(
        onTap: () {
          Widget page;
          switch (widget.type) {
            case 'fc3d':
              page = Fc3dMasterPage(
                master['masterId'],
                index: 6,
              );
              break;
            case 'pl3':
              page = Pl3MasterPage(
                master['masterId'],
                index: 6,
              );
              break;
            case 'ssq':
              page = SsqMasterPage(
                master['masterId'],
                index: 6,
              );
              break;
            case 'dlt':
              page = DltMasterPage(
                master['masterId'],
                index: 1,
              );
              break;
            case 'qlc':
              page = QlcMasterPage(
                master['masterId'],
                index: 6,
              );
              break;
          }
          AppNavigator.push(context, page, login: true);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(
            Adaptor.width(7),
            Adaptor.width(4),
            Adaptor.width(7),
            Adaptor.width(4),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: Adaptor.width(60),
                height: Adaptor.height(60),
                margin: EdgeInsets.all(Adaptor.width(4)),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.75,
                  child: CachedNetworkImage(
                    width: Adaptor.width(60),
                    height: Adaptor.height(60),
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
              ),
              Container(
                child: Text(
                  Tools.limitName(master['name'], 4),
                  style: TextStyle(
                    fontSize: Adaptor.sp(12),
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }).toList();
    return Container(
      child: Column(
        children: <Widget>[
          Wrap(
            children: views,
          ),
          InkWell(
            onTap: () {
              _loadData();
            },
            child: Container(
              height: Adaptor.height(36),
              margin: EdgeInsets.fromLTRB(
                Adaptor.width(14),
                Adaptor.width(8),
                Adaptor.width(14),
                Adaptor.width(4),
              ),
              decoration: BoxDecoration(
                color: Color(0xfff9f9f9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    IconData(0xe6c2, fontFamily: 'iconfont'),
                    size: Adaptor.sp(18),
                    color: Colors.redAccent,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Adaptor.width(2)),
                    child: Text(
                      '换一换',
                      style: TextStyle(
                        fontSize: Adaptor.sp(14),
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///加载数据
  ///
  void _loadData() {
    setState(() {
      _loaded = false;
    });
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = Map();
    params['limit'] = limit;
    request.getJson('/$current/random/vip', params: params).then((response) {
      var result = response.data;
      if (result['status'] != 200) {
        throw '加载数据错误';
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) {
          return;
        }
        setState(() {
          _loaded = true;
          _error = false;
          masters.clear();
          masters.addAll(result['data']);
        });
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
    current = widget.type;
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
