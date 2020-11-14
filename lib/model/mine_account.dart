import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

class UserAccountModel with ChangeNotifier {
  ///账户余额
  int _balance = 0;

  ///账户代金券
  int _voucher = 0;

  ///是否加载完成
  bool _loaded = false;

  ///是否加载出错
  bool _error = false;

  int get balance => _balance;

  set balance(int value) {
    _balance = value;
    notifyListeners();
  }

  int get voucher => _voucher;

  set voucher(int value) {
    _voucher = value;
    notifyListeners();
  }

  bool get loaded => _loaded;

  set loaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  bool get error => _error;

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  UserAccountModel.initialize() {
    loadBalanceInfo();
  }

  void loadBalanceInfo() {
    loaded = false;
    error = false;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/user/balance').then((response) {
      var data = response.data;
      if (data['status'] != 200) {
        throw data['message'];
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        balance = data['data']['balance'];
        voucher = data['data']['voucher'];
        error = false;
        loaded = true;
      });
    }).catchError((_) {
      loaded = true;
      error = true;
    });
  }
}
