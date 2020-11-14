import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class Pl3PickerModel with ChangeNotifier {
  ///加载状态
  LoadState _state = LoadState.loading;

  ///选项
  int _selectedIndex = 0;

  ///期号
  String _period;

  ///时间
  String _time;

  ///加载错误消息
  String _message;

  ///数据
  Map<int, List<double>> _datas = Map();

  Pl3PickerModel.initialize() {
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/pl3/hot/census').then((response) {
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
      period = data['period'];
      time = data['time'];
      putData(0, _parseData(json.decode(data['dan1'])));
      putData(1, _parseData(json.decode(data['dan2'])));
      putData(2, _parseData(json.decode(data['dan3'])));
      putData(3, _parseData(json.decode(data['com5'])));
      putData(4, _parseData(json.decode(data['com6'])));
      putData(5, _parseData(json.decode(data['com7'])));
      putData(6, _parseData(json.decode(data['kill1'])));
      putData(7, _parseData(json.decode(data['kill2'])));
      state = LoadState.success;
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  List<double> _parseData(List data) {
    return List.of(data.map((item) => double.parse(item.toString())));
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

  String get period => _period;

  set period(String value) {
    _period = value;
    notifyListeners();
  }

  String get time => _time;

  set time(String value) {
    _time = value;
    notifyListeners();
  }

  Map<int, List<double>> get datas => _datas;

  void putData(int index, List<double> data) {
    datas[index] = data;
    notifyListeners();
  }

  List<double> getData() {
    return datas[selectedIndex];
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}
