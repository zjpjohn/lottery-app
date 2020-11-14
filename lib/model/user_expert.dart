import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';

class UserExpertModel with ChangeNotifier {
  //专家信息
  UserExpert _expert;

  //是否加载完成
  bool _loaded = false;

  //是否加载出错
  bool _error = false;

  //是否显示
  bool _loading = false;

  ///是否正在提现
  bool _withdrawing = false;

  UserExpertModel.initialize() {
    loadExpertInfo();
  }

  void loadExpertInfo() {
    loaded = false;
    error = false;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/expert/info').then((response) {
      var data = response.data;
      if (data['status'] != 200) {
        error = true;
        return;
      }
      expert = UserExpert.fromJson(data['data']);
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        loaded = true;
      });
    });
  }

  void enableExpertItem({Map<String, dynamic> params, Function success}) {
    if (loading) {
      EasyLoading.showError('正在开启');
      return;
    }
    loading = true;
    HttpRequest request = HttpRequest.instance();
    EasyLoading.show();
    request.postJson('/expert/enable/item', params: params).then((response) {
      final data = response.data;
      if (data['status'] != 200) {
        EasyLoading.showError('${data['message']}');
        return;
      }
      success();
    }).catchError((error) {
      EasyLoading.showError('开启失败');
    }).whenComplete(() {
      loading = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        EasyLoading.dismiss();
      });
    });
  }

  void withdrawAction({@required String password, Function success}) {
    if (withdrawing) {
      EasyLoading.showToast('正在提现');
      return;
    }
    withdrawing = true;
    HttpRequest request = HttpRequest.instance();
    EasyLoading.show();
    request
        .postJson('/expert/withdraw', params: Map()..['password'] = password)
        .then((response) {
      final data = response.data;
      if (data['status'] != 200) {
        EasyLoading.showToast(data['message']);
        return;
      }
      income = data['data']['income'];
      withdraw = data['data']['withdraw'];
      if (success != null) {
        Future.delayed(const Duration(milliseconds: 200), () {
          success();
        });
      }
    }).catchError((err) {
      EasyLoading.showToast('提现失败');
    }).whenComplete(() {
      withdrawing = false;
    });
  }

  bool get withdrawing => _withdrawing;

  set withdrawing(bool value) {
    _withdrawing = value;
    notifyListeners();
  }

  double enableMoney() {
    return expert.withdraw / expert.ratio;
  }

  bool hasWithdraw() {
    return expert.throttle <= expert.income;
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
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

  UserExpert get expert => _expert;

  set expert(UserExpert value) {
    _expert = value;
    notifyListeners();
  }

  set fc3dEnable(int value) {
    _expert.fc3dEnable = value;
    notifyListeners();
  }

  set pl3Enable(int value) {
    _expert.pl3Enable = value;
    notifyListeners();
  }

  set ssqEnable(int value) {
    _expert.ssqEnable = value;
    notifyListeners();
  }

  set dltEnable(int value) {
    _expert.dltEnable = value;
    notifyListeners();
  }

  set qlcEnable(int value) {
    _expert.qlcEnable = value;
    notifyListeners();
  }

  set income(int income) {
    _expert.income = income;
    notifyListeners();
  }

  set withdraw(int withdraw) {
    _expert.withdraw = withdraw;
    notifyListeners();
  }
}

class UserExpert {
  int id;

  int userId;

  //专家名称
  String name;

  //专家头像
  String image;

  //专家唯一标识
  String masterId;

  //提现门槛
  int throttle;

  //兑换比例
  int ratio;

  //账户收益
  int income;

  //累计提现
  int withdraw;

  //是否启用:0-否,1-是
  int fc3dEnable;

  int pl3Enable;

  int ssqEnable;

  int dltEnable;

  int qlcEnable;

  //注册时间
  String createTime;

  //更新时间
  String updateTime;

  //对账时间
  String reconcileTime;

  UserExpert();

  UserExpert.fromJson(Map data) {
    this.id = data['id'];
    this.userId = data['userId'];
    this.name = data['name'];
    this.masterId = data['masterId'];
    this.image = data['image'];
    this.throttle = data['throttle'];
    this.ratio = data['ratio'];
    this.income = data['income'];
    this.withdraw = data['withdraw'];
    this.fc3dEnable = data['fc3dEnable'];
    this.pl3Enable = data['pl3Enable'];
    this.ssqEnable = data['ssqEnable'];
    this.dltEnable = data['dltEnable'];
    this.qlcEnable = data['qlcEnable'];
    this.createTime = data['createTime'];
    this.updateTime = data['updateTime'];
    this.reconcileTime = data['reconcileTime'];
  }
}
