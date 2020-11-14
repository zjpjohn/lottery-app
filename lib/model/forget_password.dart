import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/adaptor.dart';

/// 墨水瓶（`InkWell`）可用时使用的字体样式。
final TextStyle availableStyle = TextStyle(
  fontSize: Adaptor.sp(15.0),
  color: Colors.blue,
);

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final TextStyle unavailableStyle = TextStyle(
  fontSize: Adaptor.sp(15.0),
  color: const Color(0xFFCCCCCC),
);

typedef Callback(bool result, String message);

typedef SendCallback(bool result, String message);

class ForgetPasswordModel with ChangeNotifier {
  ///手机号
  String _phone;

  ///新密码
  String _password;

  ///验证码
  String _code;

  ///确认密码
  String _confirm;

  bool _available = true;

  String _verify = '获取验证码';

  int _seconds;

  ///提交动作是否完成
  bool _submitted = true;

  TextStyle _inkWellStyle = availableStyle;

  bool get submitted => _submitted;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['phone'] = phone;
    json['password'] = password;
    json['confirm'] = confirm;
    json['code'] = code;
    return json;
  }

  ///提交修改密码操作
  void resetPasswordAction({@required Callback callback}) {
    if (!submitted) {
      EasyLoading.showToast('正在提交');
      return;
    }
    submitted = false;
    HttpRequest request = HttpRequest.instance();
    request.postJson('/user/reset', params: toJson()).then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        callback(false, result['message']);
        submitted = true;
        return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        callback(true, '重置密码成功');
        submitted = true;
      });
    }).catchError((error) {
      callback(false, '重置失败');
      submitted = true;
    });
  }

  ///发送短信验证
  void sendSms({String phone, SendCallback callback}) {
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/sms/send',
            params: Map()
              ..['phone'] = phone
              ..['channel'] = 'reset')
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        callback(false, result['message']);
        return;
      }
      callback(true, '发送成功');
    }).catchError((err) {
      callback(false, '发送失败');
    });
  }

  set submitted(bool value) {
    _submitted = value;
    notifyListeners();
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get code => _code;

  set code(String value) {
    _code = value;
    notifyListeners();
  }

  String get confirm => _confirm;

  set confirm(String value) {
    _confirm = value;
    notifyListeners();
  }

  bool get available => _available;

  set available(bool value) {
    _available = value;
    notifyListeners();
  }

  String get verify => _verify;

  set verify(String value) {
    _verify = value;
    notifyListeners();
  }

  int get seconds => _seconds;

  set seconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  TextStyle get inkWellStyle => _inkWellStyle;

  set inkWellStyle(TextStyle value) {
    _inkWellStyle = value;
    notifyListeners();
  }
}
