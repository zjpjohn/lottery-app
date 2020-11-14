import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';

class ExpertPasswordModel with ChangeNotifier {
  String _password;

  String _confirm;

  bool _showPwd = false;

  bool _reseting = false;

  ExpertPasswordModel();

  void resetPassword({Function callback}) {
    if (reseting) {
      EasyLoading.showError('正在提交');
      return;
    }
    if (password != confirm) {
      EasyLoading.showError('密码不一致');
      return;
    }
    reseting = true;
    EasyLoading.show();
    HttpRequest request = HttpRequest.instance();
    request
        .postJson('/expert/reset',
            params: Map()
              ..['password'] = password
              ..['confirm'] = confirm)
        .then((response) {
      final data = response.data;
      if (data['status'] != 200) {
        EasyLoading.showError(data['message']);
        reseting = false;
        return;
      }
      if (callback != null) {
        callback();
      }
      reseting = false;
    }).catchError((err) {
      EasyLoading.showError('系统错误');
      reseting = false;
    });
  }

  bool get showPwd => _showPwd;

  set showPwd(bool value) {
    _showPwd = value;
    notifyListeners();
  }

  bool get reseting => _reseting;

  set reseting(bool value) {
    _reseting = value;
    notifyListeners();
  }

  String get confirm => _confirm;

  set confirm(String value) {
    _confirm = value;
    notifyListeners();
  }

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }
}
