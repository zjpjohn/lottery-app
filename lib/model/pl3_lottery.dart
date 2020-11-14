import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class Pl3LotteryModel with ChangeNotifier {
  LoadState _state = LoadState.loading;

  var _lottery;

  List _glads;

  List _masters;

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/lottery/newest?type=pai_lie3'),
      request.getJson('/pl3/glad'),
      request.getJson('/pl3/top/masters',
          params: Map()
            ..['page'] = 1
            ..['limit'] = 6),
    ]).then((values) {
      Response<Map<String, dynamic>> lotteryResponse = values[0];
      Response<Map<String, dynamic>> gladResponse = values[1];
      Response<Map<String, dynamic>> masterResponse = values[2];
      if (lotteryResponse.data['status'] != 200 ||
          gladResponse.data['status'] != 200 ||
          masterResponse.data['status'] != 200) {
        state = LoadState.error;
        return;
      }
      lottery = lotteryResponse.data['data'];
      glads = gladResponse.data['data']['data'];
      masters = masterResponse.data['data']['data'];
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

  List get masters => _masters;

  set masters(List value) {
    _masters = value;
    notifyListeners();
  }
}
