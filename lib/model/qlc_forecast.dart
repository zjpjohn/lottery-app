import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

typedef Callback(bool result, String message);

class QlcPredictModel with ChangeNotifier {
  //当前预测期号
  String period;

  //选号步骤
  int _step = 0;

  //红球
  List<String> _red = List();

  //红球杀码
  List<String> _redKill = List();

  ///提交发布状态
  bool _issuing = false;

  QlcPredictModel(this.period);

  void issueForecast({Callback callback}) {
    if (!hasData()) {
      callback(false, '请先完善号码');
      return;
    }
    if (issuing) {
      callback(false, '正在提交，请稍等');
      return;
    }
    issuing = true;
    QlcForecastDto forecastDto = QlcForecastDto()
      ..period = period
      ..red1 = redJoin(1)
      ..red2 = redJoin(2)
      ..red3 = redJoin(3)
      ..red12 = redJoin(12)
      ..red18 = redJoin(18)
      ..red22 = redJoin(22)
      ..kill3 = redKillJoin(3)
      ..kill6 = redKillJoin(6);
    HttpRequest request = HttpRequest.instance();
    request
        .postJson('/expert/issue/qlc', params: forecastDto.toJson())
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        callback(false, result['message']);
        issuing = false;
        return;
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        callback(true, result['message']);
        issuing = false;
      });
    }).catchError((err) {
      callback(false, '发布预测失败');
      issuing = false;
    });
  }

  bool hasData() {
    return _red.length >= 22 && _redKill.length >= 6;
  }

  bool get issuing => _issuing;

  set issuing(bool value) {
    _issuing = value;
    notifyListeners();
  }

  void addRed({String ball, Function overflow}) {
    if (_red.contains(ball)) {
      return;
    }
    if (_red.length >= 22) {
      if (overflow != null) {
        overflow('您已选择22个号码');
      }
      return;
    }
    _red.add(ball);
    notifyListeners();
  }

  String redJoin(int index) {
    int limit = index;
    if (_red.length < index) {
      limit = _red.length;
    }
    String target;
    _red.sublist(0, limit).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void removeRed(String ball) {
    _red.remove(ball);
    notifyListeners();
  }

  void clearRed() {
    _red.clear();
    notifyListeners();
  }

  void addRedKill({String ball, Function overflow}) {
    if (_redKill.contains(ball)) {
      return;
    }
    if (_redKill.length >= 6) {
      if (overflow != null) {
        overflow('您已选择6个号码');
      }
      return;
    }
    _redKill.add(ball);
    notifyListeners();
  }

  String redKillJoin(int index) {
    int limit = index;
    if (_redKill.length < index) {
      limit = _redKill.length;
    }
    String target;
    _redKill.sublist(0, limit).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void removeRedKill(String ball) {
    _redKill.remove(ball);
    notifyListeners();
  }

  void clearRedKill() {
    _redKill.clear();
    notifyListeners();
  }

  int get step => _step;

  set step(int value) {
    _step = value;
    notifyListeners();
  }

  List<String> get redKill => _redKill;

  set redKill(List<String> value) {
    _redKill = value;
    notifyListeners();
  }

  List<String> get red => _red;

  set red(List<String> value) {
    _red = value;
    notifyListeners();
  }
}

class QlcForecastDto {
  ///预测期号
  String period;

  ///独胆
  String red1;

  ///双胆
  String red2;

  ///三胆
  String red3;

  ///12码
  String red12;

  ///18码
  String red18;

  ///22码
  String red22;

  ///杀三码
  String kill3;

  ///杀六码
  String kill6;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['period'] = period;
    json['red1'] = red1;
    json['red2'] = red2;
    json['red3'] = red3;
    json['red12'] = red12;
    json['red18'] = red18;
    json['red22'] = red22;
    json['kill3'] = kill3;
    json['kill6'] = kill6;
    return json;
  }
}
