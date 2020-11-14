import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class QlcPredictDetailModel with ChangeNotifier {
  String _period;

  QlcForecast _forecast;

  LoadState _state = LoadState.loading;

  QlcPredictDetailModel.initialize({@required String period}) {
    _period = period;
    queryForecast();
  }

  void queryForecast() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/expert/qlc/forecast', params: Map()..['period'] = period)
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
      forecast = QlcForecast()
        ..period = data['period']
        ..opened = data['open']
        ..dan1 = data['open'] == 1
            ? Tools.parse(data['red1'])
            : Tools.split(data['red1'])
        ..dan2 = data['open'] == 1
            ? Tools.parse(data['red2'])
            : Tools.split(data['red2'])
        ..dan3 = data['open'] == 1
            ? Tools.parse(data['red3'])
            : Tools.split(data['red3'])
        ..red12 = data['open'] == 1
            ? Tools.parse(data['red12'])
            : Tools.split(data['red12'])
        ..red18 = data['open'] == 1
            ? Tools.parse(data['red18'])
            : Tools.split(data['red18'])
        ..red22 = data['open'] == 1
            ? Tools.parse(data['red22'])
            : Tools.split(data['red22'])
        ..kill3 = data['open'] == 1
            ? Tools.parse(data['kill3'])
            : Tools.split(data['kill3'])
        ..kill6 = data['open'] == 1
            ? Tools.parse(data['kill6'])
            : Tools.split(data['kill6']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get period => _period;

  QlcForecast get forecast => _forecast;

  set forecast(QlcForecast value) {
    _forecast = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class QlcForecast {
  //预测期号
  String period;

  int opened;

  //独胆
  List dan1;

  //双胆
  List dan2;

  //三胆
  List dan3;

  //12码
  List red12;

  //18码
  List red18;

  //22码
  List red22;

  //杀三
  List kill3;

  //杀六
  List kill6;
}
