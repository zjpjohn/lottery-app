import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:dio/dio.dart';

class SignModel with ChangeNotifier {
  ///签到信息
  SignInfo _signInfo;

  ///签到记录
  List<SignLog> _logs = List();

  ///是否加载
  bool _loaded = false;

  ///是否出错
  bool _error = false;

  ///是否签到中
  bool _signing = false;

  SignModel.initialize() {
    loadSignInfo();
  }

  void loadSignInfo() {
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/user/sign/info'),
      request.getJson('/user/sign/histories'),
    ]).then((values) {
      Response<Map<String, dynamic>> signData = values[0];
      Response<Map<String, dynamic>> signLogs = values[1];
      Future.delayed(const Duration(milliseconds: 300), () {
        signInfo = SignInfo()
          ..ecoupon = signData.data['data']['ecoupon']
          ..scoupon = signData.data['data']['scoupon']
          ..sthrottle = signData.data['data']['sthrottle']
          ..series = signData.data['data']['series']
          ..lastSeries = signData.data['data']['series']
          ..total = signData.data['data']['total']
          ..coupon = signData.data['data']['coupon']
          ..current = signData.data['data']['current']
          ..hasSigned = signData.data['data']['hasSigned']
          ..lastSign = signData.data['data']['lastSign'];
        if (signLogs.data['data']['data'] != null) {
          logs.addAll(
            List.of(signLogs.data['data']['data']).map(
              (log) => SignLog()
                ..type = log['type']
                ..award = log['award']
                ..signTime = log['signTime'],
            ),
          );
        }
        error = false;
        loaded = true;
      });
    }).catchError((_) {
      error = true;
      loaded = true;
    });
  }

  void signAction({@required Function callback}) {
    if (signing) {
      EasyLoading.showToast('正在签到...');
      return;
    }
    signing = true;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/user/sign').then((response) {
      int status = response.data['status'];
      if (status != 200) {
        EasyLoading.showToast(response.data['message']);
      }
      var data = response.data['data'];
      callback();
      signInfo.coupon = data['coupon'];
      signInfo.current = signInfo.current + data['award'];
      signInfo.total = data['total'];
      signInfo.lastSign = data['signTime'];
      signInfo.series = data['series'];
      signInfo.hasSigned = 1;
      signing = false;
      List<SignLog> signLogs = List()
        ..add(SignLog()
          ..type = data['type']
          ..award = data['award']
          ..signTime = data['signTime']);
      logs.forEach((log) => signLogs.add(log));
      logs
        ..clear()
        ..addAll(signLogs);
    }).catchError((error) {
      signing = false;
      EasyLoading.showToast('签到异常');
    });
  }

  bool get signing => _signing;

  set signing(bool value) {
    _signing = value;
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

  List<SignLog> get logs => _logs;

  set logs(List<SignLog> value) {
    _logs = value;
    notifyListeners();
  }

  SignInfo get signInfo => _signInfo;

  set signInfo(SignInfo value) {
    _signInfo = value;
    notifyListeners();
  }
}

class SignInfo {
  ///每天签到积分
  int ecoupon;

  ///连续签到门槛奖励积分
  int scoupon;

  ///连续签到门槛
  int sthrottle;

  ///连续签到次数
  int series;

  ///上一次连续签到
  int lastSeries;

  ///签到总次数
  int total;

  ///累计签到总积分
  int coupon;

  ///当前账户积分
  int current;

  ///是否已经签到
  int hasSigned;

  ///上一次签到时间
  String lastSign;
}

class SignLog {
  ///签到类型:1-每日签到,2-累计签到
  int type;

  ///签到奖励
  int award;

  ///签到时间
  String signTime;
}
