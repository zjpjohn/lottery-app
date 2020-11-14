import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/news/news-detail.dart';
import 'package:lottery_app/news/news/news_all.dart';

class LotteryNewsView extends StatefulWidget {
  @override
  LotteryNewsViewState createState() => new LotteryNewsViewState();
}

class LotteryNewsViewState extends State<LotteryNewsView> {
  ///新闻集合
  List _news = List();

  ///是否加载完成
  bool _loaded = false;

  ///是否页面出错
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Adaptor.width(14),
        right: Adaptor.width(14),
        bottom: Adaptor.width(24),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: Adaptor.width(12),
              right: Adaptor.width(12),
            ),
            height: Adaptor.height(40),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '彩市快讯',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: Adaptor.sp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppNavigator.push(context, NewsAllPage());
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        '更多快讯',
                        style: TextStyle(
                          fontSize: Adaptor.sp(12),
                          height: 1.2,
                          color: Color(0xffFF512F),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Adaptor.width(4)),
                        child: Icon(
                          IconData(0xe602, fontFamily: 'iconfont'),
                          size: Adaptor.sp(12),
                          color: Color(0xffFF512F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    if (_loaded) {
      if (_error) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: Adaptor.width(64),
            bottom: Adaptor.width(64),
          ),
          child: ErrorView(
            color: Colors.black26,
            message: '出错啦，点击重试',
            callback: () {
              _loadNews();
            },
          ),
        );
      }
      return _buildNewsContainer();
    }
    return _buildSkeleton();
  }

  Widget _buildNewsContainer() {
    return Container(
      child: Column(
        children: _news.map((v) {
          return Container(
            margin: EdgeInsets.only(bottom: Adaptor.width(12)),
            padding: EdgeInsets.all(Adaptor.width(12)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Adaptor.width(2))),
            child: InkWell(
              onTap: () {
                AppNavigator.push(context, NewsDetailPage(v['id']));
              },
              child: SizedBox(
                height: Adaptor.height(76),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CachedNetworkImage(
                          width: Adaptor.width(80),
                          height: Adaptor.height(76),
                          fit: BoxFit.cover,
                          imageUrl: v['header'],
                          placeholder: (context, url) => Constant.progress,
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: new Container(
                        child: Text(
                          '    ' + v['summary'],
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
        }).toList(),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      child: Column(
        children: <Widget>[
          _skeletonItem(),
          _skeletonItem(),
          _skeletonItem(),
          _skeletonItem(),
          _skeletonItem(),
        ],
      ),
    );
  }

  Widget _skeletonItem() {
    return Container(
      margin: EdgeInsets.only(bottom: Adaptor.width(12)),
      padding: EdgeInsets.all(Adaptor.width(12)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Adaptor.width(2))),
      child: SizedBox(
        height: Adaptor.height(72),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: new Container(
                width: Adaptor.width(80),
                height: Adaptor.height(72),
                margin: EdgeInsets.only(right: 10),
                color: Color(0xfffbfbfb),
                child: null,
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                height: Adaptor.height(72),
                color: Color(0xfffbfbfb),
                child: null,
              ),
              flex: 3,
            )
          ],
        ),
      ),
    );
  }

  void _loadNews() {
    setState(() {
      _loaded = false;
      _error = false;
    });
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/news/list',
            params: Map()
              ..['page'] = 1
              ..['limit'] = 5)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        setState(() {
          _loaded = true;
          _error = true;
        });
        return;
      }
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          setState(() {
            _news
              ..clear()
              ..addAll(result['data']['data']);
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
    _loadNews();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(LotteryNewsView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
