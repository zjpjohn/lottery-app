import 'package:flutter/cupertino.dart';
import 'package:lottery_app/commons/http_request.dart';

class UserShareModel with ChangeNotifier {
  ///邀请基本信息
  UserInvite _share;

  ///是否加载
  bool _loaded = false;

  ///是否出错
  bool _error = false;

  UserShareModel.initialize() {
    loadShareInfo();
  }

  void loadShareInfo() {
    HttpRequest request = HttpRequest.instance();
    loaded = false;
    error = false;
    request.getJson('/user/invite').then((response) {
      var data = response.data;
      if (data['status'] != 200) {
        error = true;
        return;
      }
      share = UserInvite.fromJson(data['data']);
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        loaded = true;
      });
    });
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

  UserInvite get share => _share;

  set share(UserInvite value) {
    _share = value;
    notifyListeners();
  }
}

class UserInvite {
  //邀请码
  String code;

  //邀请链接
  String inviteUri;

  //累计邀请人数
  int invites;

  //通过邀请累计获得代金券数量
  int vouchers;

  //每一次邀请获得代金券数量
  int voucher;

  UserInvite.fromJson(Map json) {
    this.code = json['code'];
    this.inviteUri = json['inviteUri'];
    this.invites = json['invites'];
    this.vouchers = json['rewards'];
    this.voucher = json['voucher'];
  }
}
