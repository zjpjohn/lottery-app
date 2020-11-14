import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class DltPredictDetailModel with ChangeNotifier {
  String _period;

  DltForecast _forecast;

  LoadState _state = LoadState.loading;

  DltPredictDetailModel.initialize({@required String period}) {
    _period = period;
    queryForecast();
  }

  void queryForecast() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/expert/dlt/forecast', params: Map()..['period'] = period)
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
      forecast = DltForecast()
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
        ..red10 = data['open'] == 1
            ? Tools.parse(data['red10'])
            : Tools.split(data['red10'])
        ..red20 = data['open'] == 1
            ? Tools.parse(data['red20'])
            : Tools.split(data['red20'])
        ..kill3 = data['open'] == 1
            ? Tools.parse(data['kill3'])
            : Tools.split(data['kill3'])
        ..kill6 = data['open'] == 1
            ? Tools.parse(data['kill6'])
            : Tools.split(data['kill6'])
        ..blue1 = data['open'] == 1
            ? Tools.parse(data['blue1'])
            : Tools.split(data['blue1'])
        ..blue2 = data['open'] == 1
            ? Tools.segParse(data['blue2'])
            : Tools.segSplit(data['blue2'])
        ..blue6 = data['open'] == 1
            ? Tools.segParse(data['blue6'])
            : Tools.segSplit(data['blue6'])
        ..bkill = data['open'] == 1
            ? Tools.segParse(data['bkill'])
            : Tools.segSplit(data['bkill']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get period => _period;

  DltForecast get forecast => _forecast;

  set forecast(DltForecast value) {
    _forecast = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class DltForecast {
  String period;

  int opened;

  //独胆
  List dan1;

  //双胆
  List dan2;

  //三胆
  List dan3;

  //10码
  List red10;

  //六码
  List red20;

  //杀三
  List kill3;

  //杀六
  List kill6;

  //蓝一
  List blue1;

  //蓝二
  List blue2;

  //蓝五
  List blue6;

  //杀蓝
  List bkill;
}
