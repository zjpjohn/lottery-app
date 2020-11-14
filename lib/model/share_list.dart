import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

class ShareListModel with ChangeNotifier {
  ///用户邀请记录
  List<InviteRecord> _records = List();

  ///加载状态
  bool _loaded = false;

  ///加载是否出错
  bool _error = false;

  ShareListModel.initialize() {
    loadShareRecords();
  }

  void loadShareRecords() {
    HttpRequest request = HttpRequest.instance();
    loaded = false;
    error = false;
    request.getJson('/user/invite/records').then((response) {
      var data = response.data;
      if (data['status'] != 200) {
        error = true;
        return;
      }
      if (data['data'] != null) {
        records
          ..clear()
          ..addAll(
            List.of(data['data']).map((v) {
              return InviteRecord.fromJson(v);
            }),
          );
      }
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        loaded = true;
      });
    });
  }

  List<InviteRecord> get records => _records;

  set records(List<InviteRecord> value) {
    _records = value;
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
}

class InviteRecord {
  ///标识
  int id;

  ///用户名称
  String name;

  ///用户手机号
  String phone;

  ///注册时间
  String regTime;

  InviteRecord.fromJson(Map json) {
    this.id = json['id'];
    this.name = json['name'];
    this.phone = json['phone'];
    this.regTime = json['regTime'];
  }
}
