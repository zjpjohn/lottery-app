import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class QlcLotteryModel with ChangeNotifier {
  //加载状态
  LoadState _state = LoadState.loading;

  //开奖数据
  var _lottery;

  ///中奖专家数据
  List _glads = new List();

  ///排行榜专家信息
  List _masters = List();

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/lottery/newest?type=qi_le_cai'),
      request.getJson('/qlc/glad'),
      request.getJson('/qlc/top/masters',
          params: Map()
            ..['page'] = 1
            ..['limit'] = 6),
    ]).then((values) {
      Response<Map<String, dynamic>> lotteryResponse = values[0];
      Response<Map<String, dynamic>> gladsResponse = values[1];
      Response<Map<String, dynamic>> mastersResponse = values[2];
      if (lotteryResponse.data['status'] != 200 ||
          gladsResponse.data['status'] != 200 ||
          mastersResponse.data['status'] != 200) {
        state = LoadState.error;
        return;
      }
      lottery = lotteryResponse.data['data'];
      glads = gladsResponse.data['data']['data'];
      masters = mastersResponse.data['data']['data'];
      Future.delayed(const Duration(milliseconds: 300), () {
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

  List get masters => _masters;

  set masters(List value) {
    _masters = value;
    notifyListeners();
  }
}
