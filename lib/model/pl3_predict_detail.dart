import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class Pl3PredictDetailModel with ChangeNotifier {
  String _period;

  Pl3Forecast _forecast;

  LoadState _state = LoadState.loading;

  Pl3PredictDetailModel.initialize({@required String period}) {
    _period = period;
    queryForecast();
  }

  void queryForecast() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/expert/pl3/forecast', params: Map()..['period'] = period)
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
      forecast = Pl3Forecast()
        ..period = data['period']
        ..opened = data['open']
        ..dan1 = data['open'] == 1
            ? Tools.parse(data['dan1'])
            : Tools.split(data['dan1'])
        ..dan2 = data['open'] == 1
            ? Tools.parse(data['dan2'])
            : Tools.split(data['dan2'])
        ..dan3 = data['open'] == 1
            ? Tools.parse(data['dan3'])
            : Tools.split(data['dan3'])
        ..com5 = data['open'] == 1
            ? Tools.parse(data['com5'])
            : Tools.split(data['com5'])
        ..com6 = data['open'] == 1
            ? Tools.parse(data['com6'])
            : Tools.split(data['com6'])
        ..com7 = data['open'] == 1
            ? Tools.parse(data['com7'])
            : Tools.split(data['com7'])
        ..kill1 = data['open'] == 1
            ? Tools.parse(data['kill1'])
            : Tools.split(data['kill1'])
        ..kill2 = data['open'] == 1
            ? Tools.parse(data['kill2'])
            : Tools.split(data['kill2'])
        ..comb3 = data['open'] == 1
            ? Tools.segParse(data['comb3'])
            : Tools.segSplit(data['comb3'])
        ..comb4 = data['open'] == 1
            ? Tools.segParse(data['comb4'])
            : Tools.segSplit(data['comb4'])
        ..comb5 = data['open'] == 1
            ? Tools.segParse(data['comb5'])
            : Tools.segSplit(data['comb5']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get period => _period;

  Pl3Forecast get forecast => _forecast;

  set forecast(Pl3Forecast value) {
    _forecast = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class Pl3Forecast {
  String period;

  int opened;

  List dan1;
  List dan2;
  List dan3;

  List com5;
  List com6;
  List com7;

  List kill1;
  List kill2;

  List comb3;
  List comb4;
  List comb5;
}
