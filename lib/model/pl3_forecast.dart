import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/model/fc3d_forecast.dart';

typedef Callback(bool result, String message);

class Pl3ForecastModel with ChangeNotifier {
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

  bool _issuing = false;

  Pl3ForecastModel(this.period);

  void loadForecastInfo() {}

  void issueForecast({@required Callback callback}) {
    if (!hasData()) {
      callback(false, '请先完善号码');
      return;
    }
    if (issuing) {
      callback(false, '正在提交，请耐心等待');
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

  String _danJoin(int index) {
    String target;
    _dan.sublist(0, index).forEach((v) {
      target == null ? target = v : target = target + ' ' + v;
    });
    return target == null ? '' : target;
  }

  void removeDan(String ball) {
    _dan.remove(ball);
    notifyListeners();
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

  set comb(Map<int, List<String>> value) {
    _comb = value;
    notifyListeners();
  }

  List<String> get kill => _kill;

  set kill(List<String> value) {
    _kill = value;
    notifyListeners();
  }

  List<String> get dan => _dan;

  set dan(List<String> value) {
    _dan = value;
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
