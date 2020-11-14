import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/overall/model/census_data.dart';

class SsqOverallModel with ChangeNotifier {
  ///加载状态
  LoadState _state = LoadState.loading;

  ///统计数据
  Map<int, CensusData> _datas = Map();

  ///类型
  int _type = 2;

  ///当前期号
  String _period;

  ///错误提示消息
  String _message;

  SsqOverallModel.initialize() {
    loadData(type);
  }

  void loadData(int index) {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/ssq/icai/census', params: Map()..['type'] = type)
        .then((response) {
      final result = response.data;
      message = result['message'];
      if (result['status'] == 5404 || result['status'] == 5403) {
        state = LoadState.pay;
        return;
      }
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      CensusData censusData = CensusData.fromJson(result['data']);
      period = censusData.period;
      putData(index, censusData);
      state = LoadState.success;
    }).catchError((error) {
      error = LoadState.error;
    });
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  Map<int, CensusData> get datas => _datas;

  int get type => _type;

  set type(int value) {
    _type = value;
    notifyListeners();
  }

  String get period => _period;

  set period(String value) {
    _period = value;
    notifyListeners();
  }

  void putData(int index, CensusData data) {
    datas[index] = data;
    notifyListeners();
  }

  CensusData getData() {
    return datas[type];
  }

  void switchType(int index) {
    if (type == index) {
      return;
    }
    type = index;
    if (datas[type] == null) {
      if (state == LoadState.pay) {
        return;
      }
      loadData(type);
    }
  }
}
