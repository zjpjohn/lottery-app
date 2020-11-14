import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

typedef Callback(bool result, String message);

class Fc3dForecastModel with ChangeNotifier {
  ///当前预测期号
  String period;

  ///选号步骤
  int _step = 0;

  //胆码
  List<String> _dan = List();

  //杀码
  List<String> _kill = List();

  //定位
  Map<int, List<String>> _comb = Map()
    ..[0] = List()
    ..[1] = List()
    ..[2] = List();

  ///是否提交中
  bool _issuing = false;

  Fc3dForecastModel(this.period);

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
    Number3ForecastDto forecastDto = Number3ForecastDto()
      ..period = period
      ..dan1 = _danJoin(1)
      ..dan2 = _danJoin(2)
      ..dan3 = _danJoin(3)
      ..com5 = _danJoin(5)
      ..com6 = _danJoin(6)
      ..com7 = _danJoin(7)
      ..kill1 = _killJoin(1)
      ..kill2 = _killJoin(2)
      ..comb3 = _combJoin(3)
      ..comb4 = _combJoin(4)
      ..comb5 = _combJoin(5);
    HttpRequest request = HttpRequest.instance();
    request
        .postJson('/expert/issue/fc3d', params: forecastDto.toJson())
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
    return _dan.length >= 7 &&
        _kill.length >= 2 &&
        _comb[0].length >= 5 &&
        _comb[1].length >= 5 &&
        _comb[2].length >= 5;
  }

  void addDan({String ball, Function overflow}) {
    if (_dan.contains(ball)) {
      return;
    }
    if (_dan.length >= 7) {
      if (overflow != null) {
        overflow('您已选择7个胆码');
      }
      return;
    }
    _dan.add(ball);
    notifyListeners();
  }

  void removeDan(String ball) {
    _dan.remove(ball);
    notifyListeners();
  }

  String _danJoin(int index) {
    String target;
    _dan.sublist(0, index).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void addKill({String ball, Function overflow}) {
    if (_kill.contains(ball)) {
      return;
    }
    if (_kill.length >= 2) {
      if (overflow != null) {
        overflow('您已选择2个号码');
      }
      return;
    }
    _kill.add(ball);
    notifyListeners();
  }

  String _killJoin(int index) {
    String target;
    _kill.sublist(0, index).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void removeKill(String ball) {
    _kill.remove(ball);
    notifyListeners();
  }

  void clearKill() {
    _kill.clear();
    notifyListeners();
  }

  void addComb({int index, String ball, Function overflow}) {
    final List<String> position = _comb[index];
    if (position.contains(ball)) {
      return;
    }
    if (position.length >= 5) {
      if (overflow != null) {
        overflow('您已选择5个号码');
      }
      return;
    }
    position.add(ball);
    notifyListeners();
  }

  String _combJoin(int index) {
    String b, s, g;

    ///百位
    _comb[0].sublist(0, index).forEach((v) {
      b == null ? b = v : b = b + ' ' + v;
    });

    ///十位
    _comb[1].sublist(0, index).forEach((v) {
      s == null ? s = v : s = s + ' ' + v;
    });

    ///个位
    _comb[2].sublist(0, index).forEach((v) {
      g == null ? g = v : g = g + ' ' + v;
    });

    return b + '*' + s + '*' + g;
  }

  void removeComb(int index, String ball) {
    final List<String> position = _comb[index];
    position.remove(ball);
    notifyListeners();
  }

  void clearComb() {
    _comb = Map()
      ..[0] = List()
      ..[1] = List()
      ..[2] = List();
    notifyListeners();
  }

  Map<int, List<String>> get comb => _comb;

  List<String> get kill => _kill;

  List<String> get dan => _dan;

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

class Number3ForecastDto {
  //预测期号
  String period;

  //独胆
  String dan1;

  //双胆
  String dan2;

  //三胆
  String dan3;

  //五码
  String com5;

  //六码
  String com6;

  //七码
  String com7;

  //杀一码
  String kill1;

  //杀二码
  String kill2;

  //定位三
  String comb3;

  //定位四
  String comb4;

  //定位五
  String comb5;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['period'] = period;
    json['dan1'] = dan1;
    json['dan2'] = dan2;
    json['dan3'] = dan3;
    json['com5'] = com5;
    json['com6'] = com6;
    json['com7'] = com7;
    json['kill1'] = kill1;
    json['kill2'] = kill2;
    json['cb3'] = comb3;
    json['cb4'] = comb4;
    json['cb5'] = comb5;
    return json;
  }
}
