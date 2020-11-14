import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/master/model/item-model.dart';

class DltMasterModel with ChangeNotifier {
  String _masterId;

  DltMasterDetail _detail;

  DltHistory _history;

  List<DltMasterRecord> _records;

  LoadState _state = LoadState.loading;

  DltMasterModel.initialize({String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson(
        '/dlt/master/detail',
        params: Map()..['masterId'] = masterId,
      ),
      request.getJson(
        '/dlt/history',
        params: Map()..['masterId'] = masterId,
      ),
    ]).then((values) {
      final detailResponse = values[0].data;
      final historyResponse = values[1].data;
      if (detailResponse['status'] != 200 || historyResponse['status'] != 200) {
        state = LoadState.error;
        return;
      }
      detail = DltMasterDetail.fromJson(detailResponse['data']);
      _calcHistory(historyResponse['data']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((err) {
      state = LoadState.error;
    });
  }

  void _calcHistory(List data) {
    history = DltHistory()
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
      ..red10 = data.map((item) {
        List<Model> values = Tools.parse(item['red10']);
        return ItemVo(item['period'], item['hit10'], values);
      }).toList()
      ..red20 = data.map((item) {
        List<Model> values = Tools.parse(item['red20']);
        return ItemVo(item['period'], item['hit20'], values);
      }).toList()
      ..kill3 = data.map((item) {
        List<Model> values = Tools.parse(item['kill3']);
        return ItemVo(item['period'], item['kill3Hit'], values);
      }).toList()
      ..kill6 = data.map((item) {
        List<Model> values = Tools.parse(item['kill6']);
        return ItemVo(item['period'], item['kill6Hit'], values);
      }).toList()
      ..blue1 = data.map((item) {
        List<Model> values = Tools.segParse(item['blue1']);
        return ItemVo(item['period'], item['bhit1'], values);
      }).toList()
      ..blue2 = data.map((item) {
        List<Model> values = Tools.segParse(item['blue2']);
        return ItemVo(item['period'], item['bhit2'], values);
      }).toList()
      ..blue6 = data.map((item) {
        List<Model> values = Tools.segParse(item['blue6']);
        return ItemVo(item['period'], item['bhit6'], values);
      }).toList()
      ..bkill = data.map((item) {
        List<Model> values = Tools.segParse(item['bkill']);
        return ItemVo(item['period'], item['bkillHit'], values);
      }).toList();
    records = data
        .map((item) => DltMasterRecord()
          ..period = item['period']
          ..hit2 = item['hit2']
          ..hit3 = item['hit3']
          ..hit10 = item['hit10']
          ..hit20 = item['hit20']
          ..khit3 = item['kill3Hit']
          ..khit6 = item['kill6Hit']
          ..bhit6 = item['bhit6']
          ..bkhit = item['bkillHit'])
        .toList();
  }

  String get masterId => _masterId;

  set masterId(String value) {
    _masterId = value;
    notifyListeners();
  }

  DltMasterDetail get detail => _detail;

  set detail(DltMasterDetail value) {
    _detail = value;
    notifyListeners();
  }

  DltHistory get history => _history;

  set history(DltHistory value) {
    _history = value;
    notifyListeners();
  }

  List<DltMasterRecord> get records => _records;

  set records(List<DltMasterRecord> value) {
    _records = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class DltMasterDetail {
  int id;

  String masterId;

  String name;

  String image;

  String period;

  //红球三码
  String red3Hit;

  double red3Rate;

  //红球10码
  String red10Hit;

  double red10Rate;

  //红球20码
  String red20Hit;

  double red20Rate;

  //红球杀三码
  String kill3Hit;

  double kill3Rate;

  //蓝球六码
  String blue6Hit;

  double blue6Rate;

  //蓝球杀码
  String bkillHit;

  double bkillRate;

  int updated = 0;

  int subscribe = 0;

  int vip = 0;

  String time;

  DltMasterDetail.fromJson(Map json) {
    this.id = json['id'];
    this.masterId = json['masterId'];
    this.name = json['name'];
    this.image = json['image'];
    this.period = json['period'];
    this.red3Hit = json['red3Hit'];
    this.red3Rate = json['red3Rate'];
    this.red10Hit = json['red10Hit'];
    this.red10Rate = json['red10Rate'];
    this.red20Hit = json['red20Hit'];
    this.red20Rate = json['red20Rate'];
    this.kill3Hit = json['kill3Hit'];
    this.kill3Rate = json['kill3Rate'];
    this.blue6Hit = json['blue6Hit'];
    this.blue6Rate = json['blue6Rate'];
    this.bkillHit = json['bkillHit'];
    this.bkillRate = json['bkillRate'];
    this.updated = json['updated'];
    this.subscribe = json['subscribe'];
    this.vip = json['vip'];
    this.time = json['time'];
  }
}

class DltHistory {
  //独胆数据
  List<ItemVo> dan1 = new List();

  //双胆数据
  List<ItemVo> dan2 = new List();

  //三胆数据
  List<ItemVo> dan3 = new List();

  //12码数据
  List<ItemVo> red10 = new List();

  //20码数据
  List<ItemVo> red20 = new List();

  //杀三码数据
  List<ItemVo> kill3 = new List();

  //杀六码数据
  List<ItemVo> kill6 = new List();

  //蓝一码数据
  List<ItemVo> blue1 = new List();

  //蓝二码数据
  List<ItemVo> blue2 = new List();

  //蓝六码数据
  List<ItemVo> blue6 = new List();

  //杀蓝码数据
  List<ItemVo> bkill = new List();
}

class DltMasterRecord {
  ///预测期号
  String period;

  ///红球双胆
  int hit2;

  ///红球三胆
  int hit3;

  ///红球10胆
  int hit10;

  ///红球20胆
  int hit20;

  ///红球杀三码
  int khit3;

  ///红球杀六码
  int khit6;

  ///篮球六码
  int bhit6;

  ///篮球杀码
  int bkhit;
}
