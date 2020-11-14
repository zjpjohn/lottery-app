import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';

typedef CallBack(bool success, String message);

class RegisterMasterModel with ChangeNotifier {
  ///专家名称
  String _name;

  ///专家头像
  String _image;

  ///账户提现密码
  String _password;

  ///确认密码
  String _confirm;

  ///支付宝账户真实名称
  String _aliName;

  ///支付宝账号
  String _aliAccount;

  //确认同意
  bool _agree = false;

  ///开通福彩3D预测
  int _fc3d = 0;

  ///开通排列三预测
  int _pl3 = 0;

  ///开通双色球预测
  int _ssq = 0;

  int _dlt = 0;

  ///开通七乐彩预测
  int _qlc = 0;

  //是否显密码
  bool _showPwd = false;

  ///选择头像
  List<String> _images = List();

  ///加载状态
  bool _loaded = false;

  ///加载出错
  bool _error = false;

  //签约请求状态
  bool _register = false;

  RegisterMasterModel.initialize() {
    loadAvatars();
  }

  void loadAvatars() {
    loaded = false;
    error = false;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/user/avatars').then((response) {
      final data = response.data;
      if (data['status'] != 200) {
        error = true;
      }
      List<String> avatars = List();
      data['data'].forEach((v) => avatars.add(v));
      images
        ..clear()
        ..addAll(avatars);
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      loaded = true;
    });
  }

  void registerAction({CallBack callback}) {
    if (register) {
      EasyLoading.showError('正在提交');
      return;
    }
    HttpRequest request = HttpRequest.instance();
    register = true;
    request.postJson('/expert/enable', params: toJson()).then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        callback(false, result['message']);
        register = false;
        return;
      }
      register = false;
      callback(true, '签约成功');
    }).catchError((err) {
      callback(false, '系统错误');
      register = false;
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['name'] = this.name;
    json['image'] = this.image;
    json['password'] = this.password;
    json['confirm'] = this.confirm;
    json['aliName'] = this.aliName;
    json['aliAccount'] = this.aliAccount;
    json['fc3d'] = this.fc3d;
    json['pl3'] = this.pl3;
    json['ssq'] = this.ssq;
    json['dlt'] = this.dlt;
    json['qlc'] = this.qlc;
    return json;
  }

  bool get register => _register;

  set register(bool value) {
    _register = value;
    notifyListeners();
  }

  bool hasEnableChannel() {
    return fc3d == 1 || pl3 == 1 || ssq == 1 || dlt == 1 || qlc == 1;
  }

  bool get agree => _agree;

  set agree(bool value) {
    _agree = value;
    notifyListeners();
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  bool get showPwd => _showPwd;

  set showPwd(bool value) {
    _showPwd = value;
    notifyListeners();
  }

  List<String> get images => _images;

  set images(List<String> value) {
    _images = value;
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

  String get image => _image;

  set image(String value) {
    _image = value;
    notifyListeners();
  }

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get confirm => _confirm;

  set confirm(String value) {
    _confirm = value;
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

  int get fc3d => _fc3d;

  set fc3d(int value) {
    _fc3d = value;
    notifyListeners();
  }

  int get pl3 => _pl3;

  set pl3(int value) {
    _pl3 = value;
    notifyListeners();
  }

  int get ssq => _ssq;

  set ssq(int value) {
    _ssq = value;
    notifyListeners();
  }

  int get dlt => _dlt;

  set dlt(int value) {
    _dlt = value;
    notifyListeners();
  }

  int get qlc => _qlc;

  set qlc(int value) {
    _qlc = value;
    notifyListeners();
  }
}
