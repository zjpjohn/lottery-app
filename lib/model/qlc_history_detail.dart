import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class QlcHistoryDetailModel with ChangeNotifier {
  String _masterId;

  HistoryDetail _detail;

  LoadState _state = LoadState.loading;

  QlcHistoryDetailModel.initialize({String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/qlc/forecast/history',
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
        ..red18 = Tools.parse(data['red18'])
        ..red22 = Tools.parse(data['red22'])
        ..kill3 = Tools.parse(data['kill3'])
        ..kill6 = Tools.parse(data['kill6']);
      Future.delayed(const Duration(milliseconds: 250), () {
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

  HistoryDetail get detail => _detail;

  set detail(HistoryDetail value) {
    _detail = value;
    notifyListeners();
  }

  String get masterId => _masterId;
}

class HistoryDetail {
  //预测期号
  String period;

  //独胆
  List<Model> dan1;

  //双胆
  List<Model> dan2;

  //三胆
  List<Model> dan3;

  //12码
  List<Model> red12;

  //18码
  List<Model> red18;

  //22码
  List<Model> red22;

  //杀三
  List<Model> kill3;

  //杀六
  List<Model> kill6;
}
