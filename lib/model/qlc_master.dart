import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/master/model/item-model.dart';

class QlcMasterModel with ChangeNotifier {
  String _masterId;

  QlcMasterDetail _detail;

  QlcHistory _history;

  List<QlcMasterRecord> _records;

  QlcMasterModel.initialize({String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson(
        '/qlc/master/detail',
        params: Map()..['masterId'] = masterId,
      ),
      request.getJson(
        '/qlc/history',
        params: Map()..['masterId'] = masterId,
      ),
    ]).then((values) {
      final detailResponse = values[0].data;
      final historyResponse = values[1].data;
      if (detailResponse['status'] != 200 || historyResponse['status'] != 200) {
        state = LoadState.error;
        return;
      }
      detail = QlcMasterDetail.fromJson(detailResponse['data']);
      _calcHistory(historyResponse['data']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((err) {
      state = LoadState.error;
    });
  }

  void _calcHistory(List data) {
    history = QlcHistory()
      ..dan1 = data.map((item) {
        List<Model> values = Tools.parse(item['red1']);
        return ItemVo(item['period'], item['hit1'], values);
      }).toList()
      ..dan2 = data.map((item) {
        List<Model> values = Tools.parse(item['red2']);
        return ItemVo(item['period'], item['hit2'], values);
      }).toList()
      ..dan3 = data.map((item) {
        List<Model> values = Tools.parse(item['red3']);
        return ItemVo(item['period'], item['hit3'], values);
      }).toList()
      ..red12 = data.map((item) {
        List<Model> values = Tools.parse(item['red12']);
        return ItemVo(item['period'], item['hit12'], values);
      }).toList()
      ..red18 = data.map((item) {
        List<Model> values = Tools.parse(item['red18']);
        return ItemVo(item['period'], item['hit18'], values);
      }).toList()
      ..red22 = data.map((item) {
        List<Model> values = Tools.parse(item['red22']);
        return ItemVo(item['period'], item['hit22'], values);
      }).toList()
      ..kill3 = data.map((item) {
        List<Model> values = Tools.parse(item['kill3']);
        return ItemVo(item['period'], item['kill3Hit'], values);
      }).toList()
      ..kill6 = data.map((item) {
        List<Model> values = Tools.parse(item['kill6']);
        return ItemVo(item['period'], item['kill6Hit'], values);
      }).toList();
    records = data
        .map((item) => QlcMasterRecord()
          ..period = item['period']
          ..hit2 = item['hit2']
          ..hit3 = item['hit3']
          ..hit12 = item['hit12']
          ..hit18 = item['hit18']
          ..hit22 = item['hit22']
          ..khit3 = item['kill3Hit']
          ..khit6 = item['kill6Hit'])
        .toList();
  }

  LoadState _state = LoadState.loading;

  String get masterId => _masterId;

  QlcMasterDetail get detail => _detail;

  set detail(QlcMasterDetail value) {
    _detail = value;
    notifyListeners();
  }

  QlcHistory get history => _history;

  set history(QlcHistory value) {
    _history = value;
    notifyListeners();
  }

  List<QlcMasterRecord> get records => _records;

  set records(List<QlcMasterRecord> value) {
    _records = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class QlcMasterDetail {
  int id;

  String masterId;

  String name;

  String image;

  String period;

  //字符串形式的命中率
  String red3Hit;

  //命中率
  double red3Rate;

  //红球12码
  String red12Hit;

  double red12Rate;

  //红球18码
  String red18Hit;

  double red18Rate;

  //红球22码
  String red22Hit;

  double red22Rate;

  //杀三码
  String kill3Hit;

  double kill3Rate;

  //杀六码
  String kill6Hit;

  double kill6Rate;

  int updated = 0;

  int subscribe = 0;

  int vip = 0;

  String time;

  QlcMasterDetail.fromJson(Map json) {
    this.id = json['id'];
    this.masterId = json['masterId'];
    this.name = json['name'];
    this.image = json['image'];
    this.period = json['period'];
    this.red3Hit = json['red3Hit'];
    this.red3Rate = json['red3Rate'];
    this.red12Hit = json['red12Hit'];
    this.red12Rate = json['red12Rate'];
    this.red18Hit = json['red18Hit'];
    this.red18Rate = json['red18Rate'];
    this.red22Hit = json['red22Hit'];
    this.red22Rate = json['red22Rate'];
    this.kill3Hit = json['kill3Hit'];
    this.kill3Rate = json['kill3Rate'];
    this.kill6Hit = json['kill6Hit'];
    this.kill6Rate = json['kill6Rate'];
    this.updated = json['updated'];
    this.subscribe = json['subscribe'];
    this.vip = json['vip'];
    this.time = json['time'];
  }
}

class QlcHistory {
  //独胆数据
  List<ItemVo> dan1 = new List();

  //双胆数据
  List<ItemVo> dan2 = new List();

  //三胆数据
  List<ItemVo> dan3 = new List();

  //12码数据
  List<ItemVo> red12 = new List();

  //18码数据
  List<ItemVo> red18 = new List();

  //22码数据
  List<ItemVo> red22 = new List();

  //杀三码数据
  List<ItemVo> kill3 = new List();

  //杀六码数据
  List<ItemVo> kill6 = new List();
}

class QlcMasterRecord {
  ///预测数据期号
  String period;

  ///双胆
  int hit2;

  ///三胆
  int hit3;

  ///12码
  int hit12;

  ///18码
  int hit18;

  ///22码
  int hit22;

  ///杀三码
  int khit3;

  ///杀六码
  int khit6;
}
