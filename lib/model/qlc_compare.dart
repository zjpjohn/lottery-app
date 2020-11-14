import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/compare/model/compare_data.dart';
import 'package:lottery_app/components/load_state.dart';

const int DEFAULT_LEVEL = 5;

class QlcCompareModel with ChangeNotifier {
  ///加载状态
  LoadState _state = LoadState.loading;

  ///选中类型
  int _selectedIndex = 1;

  ///选中级别
  int _level = DEFAULT_LEVEL;

  ///是否开奖
  int _open;

  ///对比数据期号
  String _period;

  ///批量对比数据
  Map<int, List> _datas = Map();

  QlcCompareModel.initialize() {
    loadData(selectedIndex);
  }

  void loadData(int index) {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/qlc/batch/compare', params: Map()..['type'] = index)
        .then((response) {
      final result = response.data;
      if (result['status'] == 5404) {
        state = LoadState.pay;
        return;
      }
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      final data = result['data'];
      open = data['opened'];
      period = data['period'];
      putData(index, calcData(data['datas']));
      state = LoadState.success;
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  List calcData(List items) {
    return List.from(items.map((item) {
      var data;
      if (open == 1) {
        data = OpenModel()
          ..masterId = item['masterId']
          ..name = item['name']
          ..rate = item['rate']
          ..series = item['series']
          ..values = Tools.parse(item['forecast']);
      } else {
        data = UnOpenModel()
          ..masterId = item['masterId']
          ..name = item['name']
          ..rate = item['rate']
          ..series = item['series']
          ..values = Tools.split(item['forecast']);
      }
      return data;
    }));
  }

  void switchType(int index) {
    if (index == selectedIndex) {
      return;
    }
    selectedIndex = index;
    //类型变动，恢复初始级别
    level = DEFAULT_LEVEL;
    if (datas[index] == null || datas[index].isEmpty) {
      if (state == LoadState.pay) {
        return;
      }
      loadData(index);
    }
  }

  List getLevelData() {
    List data = datas[selectedIndex];
    int end = data.length < level ? data.length : level;
    return data.sublist(0, end);
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  int get level => _level;

  set level(int value) {
    _level = value;
    notifyListeners();
  }

  int get open => _open;

  set open(int value) {
    _open = value;
    notifyListeners();
  }

  String get period => _period;

  set period(String value) {
    _period = value;
    notifyListeners();
  }

  Map<int, List> get datas => _datas;

  void putData(int index, List data) {
    datas[index] = data;
    notifyListeners();
  }

  List getData(int index) {
    return datas[index];
  }
}
