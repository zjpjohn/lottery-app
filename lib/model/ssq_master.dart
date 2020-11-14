import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/master/model/item-model.dart';

class SsqMasterModel with ChangeNotifier {
  String _masterId;

  SsqMasterDetail _detail;

  SsqHistory _history;

  List<SsqMasterRecord> _records;

  LoadState _state = LoadState.loading;

  String get masterId => _masterId;

  SsqHistory get history => _history;

  SsqMasterModel.initialize({String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson(
        '/ssq/master/detail',
        params: Map()..['masterId'] = masterId,
      ),
      request.getJson(
        '/ssq/history',
        params: Map()..['masterId'] = masterId,
      ),
    ]).then((values) {
      final detailResponse = values[0].data;
      final historyResponse = values[1].data;
      if (detailResponse['status'] != 200 || historyResponse['status'] != 200) {
        state = LoadState.error;
        return;
      }
      detail = SsqMasterDetail.fromJson(detailResponse['data']);
      _calcHistory(historyResponse['data']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((err) {
      state = LoadState.error;
    });
  }

  void _calcHistory(List data) {
    history = SsqHistory()
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
      ..red20 = data.map((item) {
        List<Model> values = Tools.parse(item['red20']);
        return ItemVo(item['period'], item['hit20'], values);
      }).toList()
      ..red25 = data.map((item) {
        List<Model> values = Tools.parse(item['red25']);
        return ItemVo(item['period'], item['hit25'], values);
      }).toList()
      ..kill3 = data.map((item) {
        List<Model> values = Tools.parse(item['kill3']);
        return ItemVo(item['period'], item['kill3Hit'], values);
      }).toList()
      ..kill6 = data.map((item) {
        List<Model> values = Tools.parse(item['kill6']);
        return ItemVo(item['period'], item['kill6Hit'], values);
      }).toList()
      ..blue3 = data.map((item) {
        List<Model> values = Tools.segParse(item['blue3']);
        return ItemVo(item['period'], item['bhit3'], values);
      }).toList()
      ..blue5 = data.map((item) {
        List<Model> values = Tools.segParse(item['blue5']);
        return ItemVo(item['period'], item['bhit5'], values);
      }).toList()
      ..bkill = data.map((item) {
        List<Model> values = Tools.segParse(item['bkill']);
        return ItemVo(item['period'], item['bkillHit'], values);
      }).toList();
    records = data
        .map((item) => SsqMasterRecord()
          ..period = item['period']
          ..hit2 = item['hit2']
          ..hit3 = item['hit3']
          ..hit20 = item['hit20']
          ..hit25 = item['hit25']
          ..khit3 = item['kill3Hit']
          ..khit6 = item['kill6Hit']
          ..bhit5 = item['bhit5']
          ..bkhit = item['bkillHit'])
        .toList();
  }

  SsqMasterDetail get detail => _detail;

  set detail(SsqMasterDetail value) {
    _detail = value;
    notifyListeners();
  }

  set history(SsqHistory value) {
    _history = value;
    notifyListeners();
  }

  List<SsqMasterRecord> get records => _records;

  set records(List<SsqMasterRecord> value) {
    _records = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class SsqMasterDetail {
  int id;

  String masterId;

  String name;

  String image;

  String period;

  //命中率字符串
  String red3Hit;

  //命中率
  double red3Rate;

  String red12Hit;

  double red12Rate;

  String red20Hit;

  double red20Rate;

  String red25Hit;

  double red25Rate;

  String kill3Hit;

  double kill3Rate;

  String blue5Hit;

  double blue5Rate;

  String bkillHit;

  double bkillRate;

  int updated = 0;

  int subscribe = 0;

  int vip = 0;

  String time;

  SsqMasterDetail.fromJson(Map json) {
    this.id = json['id'];
    this.masterId = json['masterId'];
    this.name = json['name'];
    this.image = json['image'];
    this.red3Hit = json['red3Hit'];
    this.red3Rate = json['red3Rate'];
    this.red12Hit = json['red12Hit'];
    this.red12Rate = json['red12Rate'];
    this.red20Hit = json['red20Hit'];
    this.red20Rate = json['red20Rate'];
    this.red25Hit = json['red25Hit'];
    this.red25Rate = json['red25Rate'];
    this.kill3Hit = json['kill3Hit'];
    this.kill3Rate = json['kill3Rate'];
    this.blue5Hit = json['blue5Hit'];
    this.blue5Rate = json['blue5Rate'];
    this.bkillHit = json['bkillHit'];
    this.bkillRate = json['bkillRate'];
    this.updated = json['updated'];
    this.subscribe = json['subscribe'];
    this.vip = json['vip'];
    this.time = json['time'];
  }
}

class SsqHistory {
  //独胆数据
  List<ItemVo> dan1 = new List();

  //双胆数据
  List<ItemVo> dan2 = new List();

  //三胆数据
  List<ItemVo> dan3 = new List();

  //12码数据
  List<ItemVo> red12 = new List();

  //20码数据
  List<ItemVo> red20 = new List();

  //25码数据
  List<ItemVo> red25 = new List();

  //杀三码数据
  List<ItemVo> kill3 = new List();

  //杀六码数据
  List<ItemVo> kill6 = new List();

  //蓝三码数据
  List<ItemVo> blue3 = new List();

  //蓝五码数据
  List<ItemVo> blue5 = new List();

  //杀蓝码数据
  List<ItemVo> bkill = new List();
}

class SsqMasterRecord {
  ///预测数据期号
  String period;

  ///双胆
  int hit2;

  ///三胆
  int hit3;

  ///20码
  int hit20;

  ///25码
  int hit25;

  ///杀三码
  int khit3;

  ///杀六码
  int khit6;

  ///篮球五码
  int bhit5;

  ///杀蓝码
  int bkhit;
}
