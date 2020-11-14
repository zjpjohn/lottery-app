import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class LotteriesModel with ChangeNotifier {
  LoadState _state = LoadState.loading;

  ///数据
  List _lotteries = new List();

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/lottery/newest/list').then((value) {
      var data = value.data['data'];
      if (value.data['status'] != 200) {
        state = LoadState.error;
        return;
      }
      lotteries = List.from(data);
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

  List get lotteries => _lotteries;

  set lotteries(List value) {
    _lotteries = value;
    notifyListeners();
  }
}
