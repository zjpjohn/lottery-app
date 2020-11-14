import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

typedef LoginCallback(bool result, String message);

class AuthModel with ChangeNotifier {
  ///用户信息
  UserInfo _user;

  ///登录token
  String _token;

  ///是否显示密码
  bool _showPass = false;

  ///登录动作状态
  bool _logined = true;

  AuthModel.initialize() {
    Map userInfo = SpUtil.getObject('user');
    String token = SpUtil.getString('token');
    if (userInfo != null && token != null) {
      _user = UserInfo.fromJson(userInfo);
      _token = token;
    }
  }

  ///登录接口
  ///[phone]:登录手机号
  ///[password]:登录密码
  void login({
    @required String phone,
    @required String password,
    @required LoginCallback callback,
  }) async {
    if (!logined) {
      callback(false, '正在登录，请耐心等待');
      return;
    }
    logined = false;
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = {'phone': phone, 'password': password};
    request.postJson('/user/login', params: params).then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        callback(false, result['message']);
        logined = true;
        return;
      }
      final data = result['data'];
      this.user = UserInfo.fromJson(data['userInfo']);
      this.token = data['token'];
      Future.delayed(const Duration(milliseconds: 500), () {
        callback(true, '登录成功');
        logined = true;
      });
    }).catchError((err) {
      callback(false, '登陆失败');
      logined = true;
    }).whenComplete(() {});
  }

  ///退出登录
  loginOut(Function callback) {
    SpUtil.remove('user');
    this.user = null;
    SpUtil.remove('token');
    this.token = null;
    if (callback != null) {
      callback();
    }
  }

  bool get showPass => _showPass;

  set showPass(bool value) {
    _showPass = value;
    notifyListeners();
  }

  String get token => _token;

  set token(String value) {
    _token = value;
    SpUtil.putString('token', value);
    notifyListeners();
  }

  UserInfo get user => _user;

  set user(UserInfo value) {
    _user = value;
    SpUtil.putObject('user', value);
    notifyListeners();
  }

  void vipMaster() {
    user = user..isMaster = 1;
    SpUtil.putObject('user', user);
    notifyListeners();
  }

  bool get logined => _logined;

  set logined(bool value) {
    _logined = value;
  }
}

class UserInfo {
  ///账户名
  String name;

  ///手机号
  String phone;

  ///账户头像
  String image;

  ///vip标识
  int isVip;

  ///是否是预测专家
  int isMaster;

  String createTime;

  UserInfo.fromJson(Map json) {
    this.name = json['name'];
    this.phone = json['phone'];
    this.image = json['image'];
    this.isVip = json['isVip'];
    this.isMaster = json['isMaster'];
    this.createTime = json['createTime'];
  }

  Map toJson() {
    Map map = Map();
    map['name'] = this.name;
    map['phone'] = this.phone;
    map['image'] = this.image;
    map['isVip'] = this.isVip;
    map['isMaster'] = this.isMaster;
    map['createTime'] = this.createTime;
    return map;
  }
}

enum LoginState { unLogin, logined, error }
