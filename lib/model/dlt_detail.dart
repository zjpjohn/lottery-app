import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class DltDetailModel with ChangeNotifier {
  String _masterId;

  DltDetail _detail;

  LoadState _state = LoadState.loading;

  DltDetailModel.initialize({String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/dlt/forecast', params: Map()..['masterId'] = masterId)
        .then((response) {
      final result = response.data;
      if (result['status'] == 5403) {
        state = LoadState.pay;
        return;
      }
      if (result['status'] == 5204) {
        state = LoadState.empty;
        return;
      }
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      final data = result['data'];
      detail = DltDetail()
        ..period = data['period']
        ..dan1 = Tools.split(data['red1'])
        ..dan2 = Tools.split(data['red2'])
        ..dan3 = Tools.split(data['red3'])
        ..red10 = Tools.split(data['red10'])
        ..red20 = Tools.split(data['red20'])
        ..kill3 = Tools.split(data['kill3'])
        ..kill6 = Tools.split(data['kill6'])
        ..blue1 = Tools.split(data['blue1'])
        ..blue2 = Tools.split(data['blue2'])
        ..blue6 = Tools.split(data['blue6'])
        ..bkill = Tools.split(data['bkill']);
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get masterId => _masterId;

  DltDetail get detail => _detail;

  set detail(DltDetail value) {
    _detail = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class DltDetail {
  String period;

  //独胆
  List<String> dan1;

  //双胆
  List<String> dan2;

  //三胆
  List<String> dan3;

  //10码
  List<String> red10;

  //六码
  List<String> red20;

  //杀三
  List<String> kill3;

  //杀六
  List<String> kill6;

  //蓝一
  List<String> blue1;

  //蓝二
  List<String> blue2;

  //蓝五
  List<String> blue6;

  //杀蓝
  List<String> bkill;
}
