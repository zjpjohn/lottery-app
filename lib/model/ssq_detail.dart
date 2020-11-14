import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class SsqDetailModel with ChangeNotifier {
  String _masterId;

  SsqDetail _detail;

  LoadState _state = LoadState.loading;

  SsqDetailModel.initialize({@required String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/ssq/forecast',
            params: Map()..['masterId'] = masterId)
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
      detail = SsqDetail()
        ..period = data['period']
        ..dan1 = Tools.split(data['red1'])
        ..dan2 = Tools.split(data['red2'])
        ..dan3 = Tools.split(data['red3'])
        ..red12 = Tools.split(data['red12'])
        ..red20 = Tools.split(data['red20'])
        ..red25 = Tools.split(data['red25'])
        ..kill3 = Tools.split(data['kill3'])
        ..kill6 = Tools.split(data['kill6'])
        ..blue3 = Tools.split(data['blue3'])
        ..blue5 = Tools.split(data['blue5'])
        ..bkill = Tools.split(data['bkill']);
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get masterId => _masterId;

  SsqDetail get detail => _detail;

  set detail(SsqDetail value) {
    _detail = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class SsqDetail {
  String period;

  //独胆
  List<String> dan1;

  //双胆
  List<String> dan2;

  //三胆
  List<String> dan3;

  //12码
  List<String> red12;

  //20码
  List<String> red20;

  //25码
  List<String> red25;

  //杀三
  List<String> kill3;

  //杀六
  List<String> kill6;

  //蓝三
  List<String> blue3;

  //蓝五
  List<String> blue5;

  //杀蓝
  List<String> bkill;
}
