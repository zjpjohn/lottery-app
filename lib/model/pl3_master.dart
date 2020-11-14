import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:lottery_app/master/model/item-model.dart';

class Pl3MasterModel with ChangeNotifier {
  String _masterId;

  Pl3MasterDetail _detail;

  Pl3History _history;

  List<Pl3MasterRecord> _records;

  Pl3MasterModel.initialize({String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson(
        '/pl3/master/detail',
        params: Map()..['masterId'] = masterId,
      ),
      request.getJson(
        '/pl3/history',
        params: Map()..['masterId'] = masterId,
      ),
    ]).then((values) {
      final detailResponse = values[0].data;
      final historyResponse = values[1].data;
      if (detailResponse['status'] != 200 || historyResponse['status'] != 200) {
        state = LoadState.error;
        return;
      }
      detail = Pl3MasterDetail.fromJson(detailResponse['data']);
      _calcHistory(historyResponse['data']);
      Future.delayed(const Duration(milliseconds: 200), () {
        state = LoadState.success;
      });
    }).catchError((err) {
      state = LoadState.error;
    });
  }

  void _calcHistory(List data) {
    history = Pl3History()
      ..dan1 = data.map((item) {
        List<Model> values = Tools.parse(item['dan1']);
        return ItemVo(item['period'], item['hit1'], values);
      }).toList()
      ..dan2 = data.map((item) {
        List<Model> values = Tools.parse(item['dan2']);
        return ItemVo(item['period'], item['hit2'], values);
      }).toList()
      ..dan3 = data.map((item) {
        List<Model> values = Tools.parse(item['dan3']);
        return ItemVo(item['period'], item['hit3'], values);
      }).toList()
      ..com5 = data.map((item) {
        List<Model> values = Tools.parse(item['com5']);
        return ItemVo(item['period'], item['hit5'], values);
      }).toList()
      ..com6 = data.map((item) {
        List<Model> values = Tools.parse(item['com6']);
        return ItemVo(item['period'], item['hit6'], values);
      }).toList()
      ..com7 = data.map((item) {
        List<Model> values = Tools.parse(item['com7']);
        return ItemVo(item['period'], item['hit7'], values);
      }).toList()
      ..kill1 = data.map((item) {
        List<Model> values = Tools.parse(item['kill1']);
        return ItemVo(item['period'], item['kill1Hit'], values);
      }).toList()
      ..kill2 = data.map((item) {
        List<Model> values = Tools.parse(item['kill2']);
        return ItemVo(item['period'], item['kill2Hit'], values);
      }).toList()
      ..comb5 = data.map((item) {
        List<Model> values = Tools.segParse(item['comb5']);
        return ItemVo(item['period'], item['comb5Hit'], values);
      }).toList();
    records = data.map((item) {
      return Pl3MasterRecord()
        ..period = item['period']
        ..hit1 = item['hit1']
        ..hit2 = item['hit2']
        ..hit3 = item['hit3']
        ..hit5 = item['hit5']
        ..hit6 = item['hit6']
        ..hit7 = item['hit7']
        ..khit1 = item['kill1Hit']
        ..khit2 = item['kill2Hit']
        ..chit5 = item['comb5Hit'];
    }).toList();
  }

  //数据加载状态
  LoadState _state = LoadState.loading;

  String get masterId => _masterId;

  Pl3MasterDetail get detail => _detail;

  set detail(Pl3MasterDetail value) {
    _detail = value;
    notifyListeners();
  }

  Pl3History get history => _history;

  set history(Pl3History value) {
    _history = value;
    notifyListeners();
  }

  List<Pl3MasterRecord> get records => _records;

  set records(List<Pl3MasterRecord> value) {
    _records = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class Pl3MasterDetail {
  int id;

  String masterId;

  String name;

  String image;

  String period;

  String hit3;

  double rate3;

  String hit6;

  double rate6;

  String hit7;

  double rate7;

  String kill1Hit;

  double kill1Rate;

  String kill2Hit;

  double kill2Rate;

  int updated;

  int subscribe;

  int vip;

  String time;

  Pl3MasterDetail.fromJson(Map json) {
    this.id = json['id'];
    this.masterId = json['masterId'];
    this.name = json['name'];
    this.image = json['image'];
    this.period = json['period'];
    this.hit3 = json['hit3'];
    this.rate3 = json['rate3'];
    this.hit6 = json['hit6'];
    this.rate6 = json['rate6'];
    this.hit7 = json['hit7'];
    this.rate7 = json['rate7'];
    this.kill1Hit = json['kill1Hit'];
    this.kill1Rate = json['kill1Rate'];
    this.kill2Hit = json['kill2Hit'];
    this.kill2Rate = json['kill2Rate'];
    this.updated = json['updated'];
    this.subscribe = json['subscribe'];
    this.vip = json['vip'];
    this.time = json['time'];
  }
}

class Pl3History {
  //独胆数据
  List<ItemVo> dan1 = new List();

  //双胆数据
  List<ItemVo> dan2 = new List();

  //三胆数据
  List<ItemVo> dan3 = new List();

  //五码数据
  List<ItemVo> com5 = new List();

  //六码数据
  List<ItemVo> com6 = new List();

  //七码数据
  List<ItemVo> com7 = new List();

  //杀一码数据
  List<ItemVo> kill1 = new List();

  //杀二码数据
  List<ItemVo> kill2 = new List();

  //组合五码数据
  List<ItemVo> comb5 = new List();
}

class Pl3MasterRecord {
  ///期号
  String period;

  ///独胆
  int hit1;

  ///双胆命中
  int hit2;

  ///三胆命中
  int hit3;

  ///五码命中
  int hit5;

  ///六码命中
  int hit6;

  ///七码命中
  int hit7;

  ///杀一码命中
  int khit1;

  ///杀二码命中
  int khit2;

  ///定位三命中
  int chit3;

  ///定位四命中
  int chit4;

  ///定位五码命中
  int chit5;
}
