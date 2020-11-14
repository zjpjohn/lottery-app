import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class SsqPredictDetailModel with ChangeNotifier {
  String _period;

  SsqForecast _forecast;

  LoadState _state = LoadState.loading;

  SsqPredictDetailModel.initialize({@required String period}) {
    _period = period;
    queryForecast();
  }

  void queryForecast() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/expert/ssq/forecast', params: Map()..['period'] = period)
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
      forecast = SsqForecast()
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
        ..red20 = data['open'] == 1
            ? Tools.parse(data['red20'])
            : Tools.split(data['red20'])
        ..red25 = data['open'] == 1
            ? Tools.parse(data['red25'])
            : Tools.split(data['red25'])
        ..kill3 = data['open'] == 1
            ? Tools.parse(data['kill3'])
            : Tools.split(data['kill3'])
        ..kill6 = data['open'] == 1
            ? Tools.parse(data['kill6'])
            : Tools.split(data['kill6'])
        ..blue3 = data['open'] == 1
            ? Tools.segParse(data['blue3'])
            : Tools.segSplit(data['blue3'])
        ..blue5 = data['open'] == 1
            ? Tools.segParse(data['blue5'])
            : Tools.segSplit(data['blue5'])
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

  SsqForecast get forecast => _forecast;

  set forecast(SsqForecast value) {
    _forecast = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class SsqForecast {
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

  //20码
  List red20;

  //25码
  List red25;

  //杀三
  List kill3;

  //杀六
  List kill6;

  //蓝三
  List blue3;

  //蓝五
  List blue5;

  //杀蓝
  List bkill;
}
