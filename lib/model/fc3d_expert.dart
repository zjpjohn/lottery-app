import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

class Fc3dExpertModel with ChangeNotifier {
  ///预测简要信息
  List<ForecastBrief> _list = List();

  ///预测开关
  IssueSwitch _issueSwitch;

  ///页码
  int _page = 1;

  ///没有大小
  int limit = 8;

  int _total = 0;

  ///加载状态
  bool _loaded = false;

  ///加载出错
  bool _error = false;

  Fc3dExpertModel.initialize() {
    loadForecastInfo();
  }

  void loadForecastInfo() {
    HttpRequest request = HttpRequest.instance();
    loaded = false;
    error = false;
    page = 1;
    Future.wait([
      request.getJson('/expert/forecast/list',
          params: Map()
            ..['page'] = page
            ..['limit'] = limit
            ..['type'] = 'fc3d'),
      request.getJson('/expert/issue/switch', params: Map()..['type'] = 'fc3d'),
    ]).then((values) {
      Map<String, dynamic> forecasts = values[0].data;
      Map<String, dynamic> issues = values[1].data;
      if (forecasts['status'] != 200 || issues['status'] != 200) {
        error = true;
        return;
      }
      total = forecasts['data']['total'];
      if (total > 0) {
        list
          ..clear()
          ..addAll(
            List.of(forecasts['data']['data'])
                .map((v) => ForecastBrief.fromJson(v)),
          );
      }
      if (issues['data'] != null) {
        issueSwitch = IssueSwitch.fromJson(issues['data']);
      }
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        loaded = true;
      });
    });
  }

  void refresh() {
    HttpRequest request = HttpRequest.instance();
    page = 1;
    request
        .getJson('/expert/forecast/list',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit
              ..['type'] = 'fc3d')
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (total > 0) {
        list
          ..clear()
          ..addAll(
            List.of(data['data']).map((v) {
              return ForecastBrief.fromJson(v);
            }),
          );
      }
    }).catchError((err) {});
  }

  void loadMore() {
    if (list.length == total) {
      return;
    }
    HttpRequest request = HttpRequest.instance();
    page = page + 1;
    request
        .getJson('/expert/forecast/list',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit
              ..['type'] = 'fc3d')
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (total > 0) {
        list
          ..clear()
          ..addAll(
            List.of(data['data']).map((v) {
              return ForecastBrief.fromJson(v);
            }),
          );
      }
    }).catchError((err) {});
  }

  String hintText() {
    if (loaded &&
        issueSwitch != null &&
        issueSwitch.enable == 1 &&
        issueSwitch.predictable == 1) {
      return '发布第${issueSwitch.period}期预测';
    }
    return '暂时不可发布';
  }

  int get total => _total;

  set total(int value) {
    _total = value;
    notifyListeners();
  }

  int get page => _page;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  bool get error => _error;

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  bool get loaded => _loaded;

  set loaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  List<ForecastBrief> get list => _list;

  set list(List<ForecastBrief> value) {
    _list = value;
    notifyListeners();
  }

  IssueSwitch get issueSwitch => _issueSwitch;

  set issueSwitch(IssueSwitch value) {
    _issueSwitch = value;
    notifyListeners();
  }
}

class ForecastBrief {
  ///预测数据记录
  int id;

  int userId;

  //预测期号
  String period;

  //专家标识
  String masterId;

  ForecastBrief.fromJson(Map data) {
    this.id = data['id'];
    this.userId = data['userId'];
    this.period = data['period'];
    this.masterId = data['masterId'];
  }
}

class IssueSwitch {
  String type;

  String period;

  int predictable;

  int enable;

  String timestamp;

  IssueSwitch.fromJson(Map json) {
    this.type = json['type'];
    this.period = json['period'];
    this.predictable = json['predictable'];
    this.enable = json['enable'];
    this.timestamp = json['timestamp'];
  }
}
