import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/custom_scroll_physics.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottery_app/commons/constants.dart';
import 'dart:convert';

import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';

class NewsDetailPage extends StatefulWidget {
  var newsId;

  NewsDetailPage(this.newsId);

  @override
  NewsDetailPageState createState() => new NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  //新闻标题
  String _title;

  //新闻来源
  String _source;

  //发布时间
  String _time;

  //新闻内容
  List _contents;

  //是否加载完成
  bool _loaded = false;

  ///加载出错
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            MAppBar('新闻详情'),
            _buildNews(),
          ],
        ),
      ),
    );
  }

  Widget _buildNews() {
    if (this._loaded) {
      if (_error) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                color: Colors.black38,
                message: '出错来，点击重试',
                callback: () {
                  _loadData();
                },
              )
            ],
          ),
        );
      }
      return Expanded(
        child: new ListView(
          physics: EasyRefreshPhysics(topBouncing: false),
          padding: EdgeInsets.fromLTRB(0, 0, 0, Adaptor.width(20)),
          children: <Widget>[
            _buildTitle(),
            _buildSubTitle(),
            _buildContent(),
          ],
        ),
      );
    } else {
      return new Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      );
    }
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Adaptor.width(20),
        Adaptor.width(15),
        Adaptor.width(20),
        0,
      ),
      alignment: Alignment.center,
      child: Text(
        _textIndent(_title, 8),
        maxLines: 2,
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
        style: TextStyle(
          color: Colors.black87,
          fontSize: Adaptor.sp(18),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _textIndent(String text, int num) {
    String indent = '';
    for (int i = 0; i < num; i++) {
      indent += ' ';
    }
    text = indent + text.trim();
    return text;
  }

  Widget _buildSubTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        0,
        Adaptor.width(10),
        0,
        Adaptor.width(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Adaptor.width(10)),
            child: Text(
              '来源：$_source',
              style: TextStyle(
                color: Colors.black45,
                fontSize: Adaptor.sp(14),
              ),
            ),
          ),
          Container(
            child: Text(
              '时间：$_time',
              style: TextStyle(
                color: Colors.black45,
                fontSize: Adaptor.sp(14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    List<Widget> views = new List();
    _contents.forEach((item) {
      if (item['type'] == 1) {
        //文本
        views.add(Container(
          padding: EdgeInsets.fromLTRB(
            Adaptor.width(10),
            0,
            Adaptor.width(10),
            0,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            _textIndent(item['content'], 4),
            maxLines: 100,
            style: TextStyle(
              color: Colors.black87,
              fontSize: Adaptor.sp(16),
            ),
          ),
        ));
      }
      if (item['type'] == 2) {
        //图片
        views.add(
          new Container(
            padding: EdgeInsets.fromLTRB(
              Adaptor.width(10),
              Adaptor.width(12),
              0,
              Adaptor.width(12),
            ),
            margin: EdgeInsets.only(right: 10),
            child: new CachedNetworkImage(
              width: Adaptor.width(130),
              height: Adaptor.height(130),
              fit: BoxFit.cover,
              imageUrl: item['content'],
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        );
      }
    });
    return new Container(
      child: Column(
        children: views,
      ),
    );
  }

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = new Map();
    params['id'] = widget.newsId;
    request.getJson('/news/detail', params: params).then((response) {
      var data = response.data['data'];
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            this._title = data['title'];
            this._source = data['source'];
            this._time = data['time'];
            this._contents = json.decode(data['content']);
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
