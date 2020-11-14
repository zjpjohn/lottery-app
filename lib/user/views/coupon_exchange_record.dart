import 'package:flutter/material.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/app_navigator.dart';

class CouponExchangeView extends StatefulWidget {
  @override
  CouponExchangeViewState createState() => new CouponExchangeViewState();
}

class CouponExchangeViewState extends State<CouponExchangeView> {
  ///积分兑换记录
  List<ExchangeRecord> records = List();

  ///是否加载完成
  bool _loaded = false;

  ///是否加载出错
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 9.0 / 16.0,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: const Text(
                    "兑换记录",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 14,
                  bottom: 14,
                  child: InkWell(
                    onTap: () {
                      AppNavigator.goBack(context);
                    },
                    child: Container(
                      child: Icon(
                        IconData(0xe683, fontFamily: 'iconfont'),
                        size: 17,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Constant.line,
            _buildContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer() {
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
                _loadExchangeRecord();
              }),
            ],
          ),
        );
      }
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: _exchangeRecords(),
          ),
        ),
      );
    }
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Constant.loading(),
        ],
      ),
    );
  }

  List<Widget> _exchangeRecords() {
    List<Widget> views = List();
    if (records.length > 0) {
      views.addAll(
        records
            .map(
              (log) => Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${log.timestamp}',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Text(
                                '-${log.coupon}',
                                style: TextStyle(
                                  color: Color(0xffFF421A),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '积分',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Text(
                                '+${log.voucher}',
                                style: TextStyle(
                                  color: Color(0xffFF421A),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '代金券',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black12,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      );
    } else {
      views.add(
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 6),
                child: Icon(
                  IconData(0xe62b, fontFamily: 'iconfont'),
                  size: 84,
                  color: Color(0xffececec),
                ),
              ),
              Text(
                '没有兑换记录',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black12,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return views;
  }

  void _loadExchangeRecord() {
    HttpRequest request = HttpRequest.instance();
    request.getJson('/user/exc/histories').then((response) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            if (response.data['data']['data'] != null) {
              records.addAll(
                List.of(response.data['data']['data']).map(
                  (item) => ExchangeRecord()
                    ..coupon = item['coupon']
                    ..voucher = item['voucher']
                    ..timestamp = item['timestamp'],
                ),
              );
            }
            _error = false;
            _loaded = true;
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
    _loadExchangeRecord();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

///积分兑换记录
class ExchangeRecord {
  ///兑换的代金券
  int voucher;

  ///兑换消耗的积分
  int coupon;

  ///兑换时间戳
  String timestamp;
}
