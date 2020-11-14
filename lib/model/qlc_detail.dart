import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class QlcDetailModel with ChangeNotifier {
  String _masterId;

  QlcDetail _detail;

  LoadState _state = LoadState.loading;

  QlcDetailModel.initialize({@required String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/qlc/forecast', params: Map()..['masterId'] = masterId)
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
      detail = QlcDetail()
        ..period = data['period']
        ..dan1 = Tools.split(data['red1'])
        ..dan2 = Tools.split(data['red2'])
        ..dan3 = Tools.split(data['red3'])
        ..red12 = Tools.split(data['red12'])
        ..red18 = Tools.split(data['red18'])
        ..red22 = Tools.split(data['red22'])
        ..kill3 = Tools.split(data['kill3'])
        ..kill6 = Tools.split(data['kill6']);
      Future.delayed(const Duration(milliseconds: 250), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get masterId => _masterId;

  QlcDetail get detail => _detail;

  set detail(QlcDetail value) {
    _detail = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class QlcDetail {
  //预测期号
  String period;

  //独胆
  List<String> dan1;

  //双胆
  List<String> dan2;

  //三胆
  List<String> dan3;

  //12码
  List<String> red12;

  //18码
  List<String> red18;

  //22码
  List<String> red22;

  //杀三
  List<String> kill3;

  //杀六
  List<String> kill6;
}
