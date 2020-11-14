import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

class VipPackageModel with ChangeNotifier {
  ///会员套餐
  List<PackageInfo> _packs = List();

  ///福彩3D专家
  List<TopMaster> _fc3dMasters = List();

  ///排列三专家
  List<TopMaster> _pl3Masters = List();

  int _index = 0;

  bool _loaded = false;

  bool _error = false;

  VipPackageModel.initialize() {
    loadPackages();
  }

  void loadPackages() {
    HttpRequest request = HttpRequest.instance();
    loaded = false;
    error = false;
    Future.wait([
      request.getJson('/user/packs'),
      request.getJson('/fc3d/top/masters',
          params: Map()
            ..['page'] = 1
            ..['limit'] = 8),
      request.getJson('/pl3/top/masters',
          params: Map()
            ..['page'] = 1
            ..['limit'] = 8)
    ]).then((values) {
      final packsResp = values[0].data;
      final fc3dResp = values[1].data;
      final pl3Resp = values[2].data;
      if (packsResp['status'] != 200 ||
          fc3dResp['status'] != 200 ||
          pl3Resp['status'] != 200) {
        error = true;
        return;
      }
      packs
        ..clear()
        ..addAll(
          List.of(packsResp['data']).map(
            (v) => PackageInfo.fromJson(v),
          ),
        );
      fc3dMasters
        ..clear()
        ..addAll(
          List.of(fc3dResp['data']['data']).map((v) => TopMaster.fromJson(v)),
        );
      pl3Masters
        ..clear()
        ..addAll(
          List.of(pl3Resp['data']['data']).map((v) => TopMaster.fromJson(v)),
        );
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 200), () {
        loaded = true;
      });
    });
  }

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  List<PackageInfo> get packs => _packs;

  set packs(List<PackageInfo> value) {
    _packs = value;
    notifyListeners();
  }

  List<TopMaster> get fc3dMasters => _fc3dMasters;

  set fc3dMasters(List<TopMaster> value) {
    _fc3dMasters = value;
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

  List<TopMaster> get pl3Masters => _pl3Masters;

  set pl3Masters(List<TopMaster> value) {
    _pl3Masters = value;
    notifyListeners();
  }
}

class PackageInfo {
  int id;

  String packId;

  String type;

  String name;

  double price;

  double discount;

  int expire;

  int userId;

  String start;

  String end;

  List<PackPrivilege> privileges;

  PackageInfo.fromJson(Map<String, dynamic> data) {
    this.id = data['id'];
    this.packId = data['packId'];
    this.type = data['type'];
    this.name = data['name'];
    this.price = data['price'];
    this.discount = data['discount'];
    this.expire = data['expire'];
    this.userId = data['userId'];
    this.start = data['start'];
    this.end = data['end'];
    this.privileges = List.of(
      List.of(data['privileges']).map((v) => PackPrivilege.fromJson(v)),
    );
  }
}

class PackPrivilege {
  int id;

  String packId;

  String name;

  String icon;

  int indicator;

  String content;

  PackPrivilege.fromJson(Map<String, dynamic> data) {
    this.id = data['id'];
    this.packId = data['packId'];
    this.name = data['name'];
    this.icon = data['icon'];
    this.indicator = data['indicator'];
    this.content = data['content'];
  }
}

class TopMaster {
  //期号
  String period;

  //专家标识
  String masterId;

  //专家名称
  String name;

  //专家头像
  String image;

  //排名
  int rank;

  TopMaster.fromJson(Map<String, dynamic> json) {
    this.period = json['period'];
    this.masterId = json['masterId'];
    this.name = json['name'];
    this.image = json['image'];
    this.rank = json['rank'];
  }
}
