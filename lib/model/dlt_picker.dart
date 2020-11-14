import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class DltPickerModel with ChangeNotifier{
  LoadState _state = LoadState.loading;

  int _selectedIndex = 0;

  String _time;

  String _period;

  String _message;

  Map<int, List<double>> _datas = Map();

  DltPickerModel.initialize() {
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/dlt/hot/census').then((response) {
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
      putData(0, _parseData(json.decode(data['red1'])));
      putData(1, _parseData(json.decode(data['red2'])));
      putData(2, _parseData(json.decode(data['red3'])));
      putData(3, _parseData(json.decode(data['red10'])));
      putData(4, _parseData(json.decode(data['red20'])));
      putData(5, _parseData(json.decode(data['kill3'])));
      putData(6, _parseData(json.decode(data['kill6'])));
      putData(7, _parseData(json.decode(data['blue1'])));
      putData(8, _parseData(json.decode(data['blue2'])));
      putData(9, _parseData(json.decode(data['blue6'])));
      putData(10, _parseData(json.decode(data['bkill'])));
      state = LoadState.success;
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  List<double> _parseData(List data) {
    return List.of(data.map((item) => double.parse(item.toString())));
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  String get time => _time;

  set time(String value) {
    _time = value;
    notifyListeners();
  }

  String get period => _period;

  set period(String value) {
    _period = value;
    notifyListeners();
  }

  String get message => _message;

  set message(String value) {
    _message = value;
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
}
