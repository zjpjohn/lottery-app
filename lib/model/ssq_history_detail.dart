import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class SsqHistoryDetailModel with ChangeNotifier {
  String _masterId;

  HistoryDetail _detail;

  LoadState _state = LoadState.loading;

  SsqHistoryDetailModel.initialize({@required String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/ssq/forecast/history',
            params: Map()..['masterId'] = masterId)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      final data = result['data'];
      if (data == null) {
        state = LoadState.empty;
        return;
      }
      detail = HistoryDetail()
        ..period = data['period']
        ..dan1 = Tools.parse(data['red1'])
        ..dan2 = Tools.parse(data['red2'])
        ..dan3 = Tools.parse(data['red3'])
        ..red12 = Tools.parse(data['red12'])
        ..red20 = Tools.parse(data['red20'])
        ..red25 = Tools.parse(data['red25'])
        ..kill3 = Tools.parse(data['kill3'])
        ..kill6 = Tools.parse(data['kill6'])
        ..blue3 = Tools.parse(data['blue3'])
        ..blue5 = Tools.parse(data['blue5'])
        ..bkill = Tools.parse(data['bkill']);
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get masterId => _masterId;

  HistoryDetail get detail => _detail;

  set detail(HistoryDetail value) {
    _detail = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class HistoryDetail {
  String period;

  //独胆
  List<Model> dan1;

  //双胆
  List<Model> dan2;

  //三胆
  List<Model> dan3;

  //12码
  List<Model> red12;

  //20码
  List<Model> red20;

  //25码
  List<Model> red25;

  //杀三
  List<Model> kill3;

  //杀六
  List<Model> kill6;

  //蓝三
  List<Model> blue3;

  //蓝五
  List<Model> blue5;

  //杀蓝
  List<Model> bkill;
}
