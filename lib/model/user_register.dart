import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/adaptor.dart';

typedef RegisterCallback(bool result, String message);

typedef SendCallback(bool result, String message);

///可用时使用的字体样式。
final TextStyle availableStyle = TextStyle(
  fontSize: Adaptor.sp(15.0),
  color: Colors.blue,
);

///不可用时使用的样式。
final TextStyle unavailableStyle = TextStyle(
  fontSize: Adaptor.sp(15.0),
  color: const Color(0xFFCCCCCC),
);

class UserRegisterModel with ChangeNotifier {
  ///注册手机号
  String _phone;

  ///注册密码
  String _password;

  ///注册确认密码
  String _confirm;

  ///手机验证码
  String _code;

  ///邀请码
  String _invite;

  ///邀请渠道
  String _channel = '3';

  ///发送短信验证码按钮是否可用
  bool _available = true;

  ///倒计时秒数
  int _seconds;

  ///短信验证码文字
  String _verify = '获取验证码';

  ///提交动作状态
  bool _submitted = true;

  String get verify => _verify;

  ///短信验证码按钮文字样式
  TextStyle _inkWellStyle = availableStyle;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['phone'] = phone;
    json['password'] = password;
    json['code'] = code;
    json['confirm'] = confirm;
    if (invite != null) {
      json['invite'] = invite;
    }
    if (channel != null) {
      json['channel'] = channel;
    }
    return json;
  }

  ///用户注册
  void userRegister({@required RegisterCallback callback}) {
    if (!submitted) {
      EasyLoading.showToast('正在提交...');
      return;
    }
    submitted = false;
    HttpRequest request = HttpRequest.instance();
    request.postJson('/user/register', params: toJson()).then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        callback(false, result['message']);
        submitted = true;
        return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        callback(true, '注册成功');
        submitted = true;
      });
    }).catchError((error) {
      callback(false, '注册失败');
      submitted = true;
    });
  }

  ///发送短信验证码
  void sendSms({@required String phone, SendCallback callback}) {
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/sms/send',
            params: Map()
              ..['phone'] = phone
              ..['channel'] = 'reg')
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

  bool get submitted => _submitted;

  set submitted(bool value) {
    _submitted = value;
    notifyListeners();
  }

  TextStyle get inkWellStyle => _inkWellStyle;

  set inkWellStyle(TextStyle value) {
    _inkWellStyle = value;
    notifyListeners();
  }

  set verify(String value) {
    _verify = value;
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

  get confirm => _confirm;

  set confirm(String value) {
    _confirm = value;
    notifyListeners();
  }

  set code(String value) {
    _code = value;
    notifyListeners();
  }

  bool get available => _available;

  set available(bool value) {
    _available = value;
    notifyListeners();
  }

  int get seconds => _seconds;

  set seconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  String get invite => _invite;

  set invite(String value) {
    if (value != null) {
      _invite = value;
      notifyListeners();
    }
  }

  String get channel => _channel;

  set channel(String value) {
    if (value != null) {
      _channel = value;
      notifyListeners();
    }
  }
}
