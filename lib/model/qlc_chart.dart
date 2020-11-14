import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/comprehensive/model/census_data.dart';

class QlcChartModel with ChangeNotifier {
  ///加载状态
  LoadState _state = LoadState.loading;

  ///数据类型
  int _type = 2;

  ///综合分析期号
  String _period;

  ///错误提示消息
  String _message;

  ///分析数据
  Map<int, CensusData> _datas = Map();

  QlcChartModel.initialize() {
    loadData(type);
  }

  void loadData(int index) {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/qlc/vip/census', params: Map()..['type'] = index)
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
      final data = result['data'];
      CensusData censusData = CensusData.fromJson(data);
      putData(index, censusData);
      period = censusData.period;
      state = LoadState.success;
    }).catchError((error) {
      state = LoadState.error;
      message = '系统错误';
    });
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

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

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

  Map<int, CensusData> get datas => _datas;

  String get message => _message;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  void putData(int index, CensusData data) {
    datas[index] = data;
    notifyListeners();
  }

  CensusData getData() {
    return datas[type];
  }
}
