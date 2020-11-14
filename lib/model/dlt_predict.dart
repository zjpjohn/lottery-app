import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

typedef Callback(bool result, String message);

class DltPredictModel with ChangeNotifier {
  ///当前预测期号
  String period;

  ///选号步骤
  int _step = 0;

  ///红球
  List<String> _red = List();

  ///红球杀码
  List<String> _redKill = List();

  ///篮球
  List<String> _blue = List();

  ///篮球杀码
  List<String> _blueKill = List();

  ///是否提交中
  bool _issuing = false;

  DltPredictModel(this.period);

  void issueForecast({Callback callback}) {
    if (!hasData()) {
      callback(false, '请先完善选号');
      return;
    }
    if (issuing) {
      callback(false, '正在提交，请稍等');
      return;
    }
    issuing = true;
    DltForecastDto forecastDto = DltForecastDto()
      ..period = period
      ..red1 = redJoin(1)
      ..red2 = redJoin(2)
      ..red3 = redJoin(3)
      ..red10 = redJoin(10)
      ..red20 = redJoin(20)
      ..rk3 = redKillJoin(3)
      ..rk6 = redKillJoin(6)
      ..blue1 = blueJoin(1)
      ..blue2 = blueJoin(2)
      ..blue6 = blueJoin(6)
      ..bk = blueKillJoin(3);
    HttpRequest request = HttpRequest.instance();
    request
        .postJson('/expert/issue/dlt', params: forecastDto.toJson())
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
    return _red.length >= 20 &&
        _redKill.length >= 6 &&
        _blue.length >= 6 &&
        _blueKill.length >= 3;
  }

  void addRed({String ball, Function overflow}) {
    if (_red.contains(ball)) {
      return;
    }
    if (_red.length >= 20) {
      if (overflow != null) {
        overflow('您已选择20个红球');
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
        overflow('您已选择6个红球');
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

  void addBlue({String ball, Function overflow}) {
    if (_blue.contains(ball)) {
      return;
    }
    if (_blue.length >= 6) {
      if (overflow != null) {
        overflow('您已选择6个蓝球');
      }
      return;
    }
    _blue.add(ball);
    notifyListeners();
  }

  String blueJoin(int index) {
    int limit = index;
    if (_blue.length < index) {
      limit = _blue.length;
    }
    String target;
    _blue.sublist(0, limit).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void removeBlue(String ball) {
    _blue.remove(ball);
    notifyListeners();
  }

  void clearBlue() {
    _blue.clear();
    notifyListeners();
  }

  void addBlueKill({String ball, Function overflow}) {
    if (_blueKill.contains(ball)) {
      return;
    }
    if (_blueKill.length >= 3) {
      if (overflow != null) {
        overflow('您已选择3个蓝球');
      }
      return;
    }
    _blueKill.add(ball);
    notifyListeners();
  }

  String blueKillJoin(int index) {
    int limit = index;
    if (_blueKill.length < index) {
      limit = _blueKill.length;
    }
    String target;
    _blueKill.sublist(0, limit).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void removeBlueKill(String ball) {
    _blueKill.remove(ball);
    notifyListeners();
  }

  void clearBlueKill() {
    _blueKill.clear();
    notifyListeners();
  }

  List<String> get blueKill => _blueKill;

  set blueKill(List<String> value) {
    _blueKill = value;
    notifyListeners();
  }

  List<String> get blue => _blue;

  set blue(List<String> value) {
    _blue = value;
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

  int get step => _step;

  set step(int value) {
    _step = value;
    notifyListeners();
  }

  bool get issuing => _issuing;

  set issuing(bool value) {
    _issuing = value;
    notifyListeners();
  }
}

class DltForecastDto {
  ///预测期号
  String period;

  ///红球独胆
  String red1;

  ///红球双胆
  String red2;

  ///红球三胆
  String red3;

  ///红球10码
  String red10;

  ///红球20码
  String red20;

  ///红球杀三码
  String rk3;

  ///红球杀六码
  String rk6;

  ///篮球一码
  String blue1;

  ///篮球双胆
  String blue2;

  ///篮球六码
  String blue6;

  ///篮球杀码
  String bk;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['period'] = period;
    json['red1'] = red1;
    json['red2'] = red2;
    json['red3'] = red3;
    json['red10'] = red10;
    json['red20'] = red20;
    json['rk3'] = rk3;
    json['rk6'] = rk6;
    json['blue1'] = blue1;
    json['blue2'] = blue2;
    json['blue6'] = blue6;
    json['bk'] = bk;
    return json;
  }
}
