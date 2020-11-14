import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class SsqLotteryModel with ChangeNotifier {
  LoadState _state = LoadState.loading;

  //中奖信息
  var _lottery;

  ///中奖专家
  List _glads = new List();

  ///红球排行专家
  List _rMasters = List();

  ///篮球排行专家
  List _bMasters = List();

  void loadData() {
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/lottery/newest?type=shuang_se_qiu'),
      request.getJson('/ssq/glad'),
      request.getJson('/ssq/top/masters',
          params: Map()
            ..['type'] = 0
            ..['limit'] = 6),
      request.getJson('/ssq/top/masters',
          params: Map()
            ..['type'] = 1
            ..['limit'] = 6),
    ]).then((values) {
      Response<Map<String, dynamic>> lotteryResponse = values[0];
      Response<Map<String, dynamic>> gladsResponse = values[1];
      Response<Map<String, dynamic>> rMastersResponse = values[2];
      Response<Map<String, dynamic>> bMastersResponse = values[3];
      if (lotteryResponse.data['status'] != 200 ||
          gladsResponse.data['status'] != 200 ||
          rMastersResponse.data['status'] != 200 ||
          bMastersResponse.data['status'] != 200) {
        state = LoadState.error;
        return;
      }
      lottery = lotteryResponse.data['data'];
      glads = gladsResponse.data['data']['data'];
      rMasters = rMastersResponse.data['data']['data'];
      bMasters = bMastersResponse.data['data']['data'];
      Future.delayed(Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  get lottery => _lottery;

  set lottery(value) {
    _lottery = value;
    notifyListeners();
  }

  List get glads => _glads;

  set glads(List value) {
    _glads = value;
    notifyListeners();
  }

  List get rMasters => _rMasters;

  set rMasters(List value) {
    _rMasters = value;
    notifyListeners();
  }

  List get bMasters => _bMasters;

  set bMasters(List value) {
    _bMasters = value;
    notifyListeners();
  }
}
