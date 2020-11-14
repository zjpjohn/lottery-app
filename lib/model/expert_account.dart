import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';

class ExpertAccountModel with ChangeNotifier {
  //支付宝真实姓名
  String _aliName;

  //支付宝账号
  String _aliAccount;

  //编辑状态
  bool _editing = false;

  ExpertAccountModel();

  void editAccountAction({Function success}) {
    if (editing) {
      EasyLoading.showError('正在提交');
      return;
    }
    editing = true;
    EasyLoading.show();
    HttpRequest request = HttpRequest.instance();
    request
        .postJson('/expert/reset/acct',
            params: Map()
              ..['aliName'] = aliName
              ..['aliAccount'] = aliAccount)
        .then((response) {
      final data = response.data;
      if (data['status'] != 200) {
        EasyLoading.showError(data['message']);
        editing = false;
        return;
      }
      if (success != null) {
        success();
      }
      editing = false;
    }).catchError((err) {
      EasyLoading.showError('系统错误');
      editing = false;
    });
  }

  bool get editing => _editing;

  set editing(bool value) {
    _editing = value;
    notifyListeners();
  }

  String get aliName => _aliName;

  set aliName(String value) {
    _aliName = value;
    notifyListeners();
  }

  String get aliAccount => _aliAccount;

  set aliAccount(String value) {
    _aliAccount = value;
    notifyListeners();
  }
}
