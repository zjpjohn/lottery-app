import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottery_app/commons/mappbar.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/news/news-detail.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/app_navigator.dart';

class NewsAllPage extends StatefulWidget {
  @override
  NewsAllPageState createState() => new NewsAllPageState();
}

class NewsAllPageState extends State<NewsAllPage>
    with AutomaticKeepAliveClientMixin {
  //新闻集合
  List _news = new List();

  ///是否加载完成
  bool _loaded = false;

  ///是否页面错误
  bool _error = false;

  int _page = 1;

  int _limit = 10;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            MAppBar('彩市快讯'),
            _buildContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer() {
    if (this._loaded) {
      if (_error) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ErrorView(
                color: Colors.black38,
                message: '出错啦，点击重试',
                callback: () {
                  _loadData();
                },
              ),
            ],
          ),
        );
      }
      return Expanded(
        child: EasyRefresh(
          header: DeliveryHeader(),
          footer: PhoenixFooter(),
          child: ListView.builder(
            padding: EdgeInsets.only(top: Adaptor.width(10)),
            itemCount: _news.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemView(context, index);
            },
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500), () {
              _refresh();
            });
          },
          onLoad: () async {
            await Future.delayed(const Duration(milliseconds: 1200), () {
              _loadMore();
            });
          },
        ),
      );
    } else {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Constant.loading(),
          ],
        ),
      );
    }
  }

  Widget _itemView(BuildContext context, int index) {
    var item = _news[index];
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Adaptor.width(14),
        horizontal: Adaptor.width(16),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: Adaptor.width(0.4),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(context, NewsDetailPage(item['id']));
        },
        child: SizedBox(
          height: Adaptor.height(76),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: Adaptor.width(10)),
                  child: new CachedNetworkImage(
                    width: Adaptor.width(80),
                    height: Adaptor.height(76),
                    fit: BoxFit.cover,
                    imageUrl: item['header'],
                    placeholder: (context, url) => Constant.progress,
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: new Container(
                  child: Text(
                    '    ' + item['summary'],
                    textAlign: TextAlign.left,
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xff3c3c3c),
                      fontSize: Adaptor.sp(13),
                    ),
                  ),
                ),
                flex: 3,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadData() {
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = new Map();
    params['page'] = _page;
    params['limit'] = _limit;
    request.getJson('/news/list', params: params).then((response) {
      List data = response.data['data']['data'];
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            this._news.clear();
            this._news.addAll(data);
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
    request.getJson('/news/list', params: params).then((response) {
      setState(() {
        this._news.clear();
        this._news.addAll(response.data['data']['data']);
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
    request.getJson('/news/list', params: params).then((response) {
      setState(() {
        this._news.addAll(response.data['data']['data']);
        this._loaded = true;
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
