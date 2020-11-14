import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/error_widget.dart';
import 'package:lottery_app/components/load_state.dart';

class GlobalConfigModel with ChangeNotifier {
  ///系统全局配置
  GlobalConfig _config;

  //全局配置加载状态
  LoadState _state = LoadState.loading;

  GlobalConfigModel.initialize() {
    loadConfig();
  }

  void loadConfig() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/global').then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        state = LoadState.error;
        EasyLoading.showToast(result['message']);
        return;
      }
      config = GlobalConfig.fromJson(result['data']);
      state = LoadState.success;
    }).catchError((error) {
      state = LoadState.error;
      EasyLoading.showToast('加载错误');
    });
  }

  Widget error() {
    return ErrorView(
      message: '重新加载',
      callback: () {
        loadConfig();
      },
    );
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  GlobalConfig get config => _config;

  set config(GlobalConfig value) {
    _config = value;
    notifyListeners();
  }
}

class GlobalConfig {
  //用户分享邀请获得代金券金额
  int inviteVoucher;

  //下载链接
  String inviteUri;

  //系统默认激活用户头像
  String enableAvatar;

  //系统默认未激活用户头像
  String disableAvatar;

  //账户允许提现门槛
  int withdrawThrottle;

  //提现汇率:1元人民币等于多少金币
  int withdrawRatio;

  //福彩3D收费专家查看一次多少金币
  int fc3dFee;

  //福彩3D一次查看最多允许代金券冲抵数量
  int fc3dVoucher;

  //排列三收费专家查看一次多少金币
  int pl3Fee;

  //排列三一次查看最多允许代金券冲抵数量
  int pl3Voucher;

  //双色球收费专家查看一次多少金币
  int ssqFee;

  //双色球一次查看最多允许代金券冲抵数量
  int ssqVoucher;

  //大乐透收费专家查看一次多少金币
  int dltFee;

  //大乐透一次查看最多允许代金券冲抵数量
  int dltVoucher;

  //七乐彩收费专家查看一次多少金币
  int qlcFee;

  //七乐彩一次查看最多允许代金券冲抵数量
  int qlcVoucher;

  //每日签到积分
  int every;

  //连续签到大额积分奖励
  int series;

  //连续签到门槛
  int seriesThrottle;

  //积分兑换门槛
  int throttle;

  //积分兑换汇率
  int exchange;

  GlobalConfig.fromJson(Map json) {
    this.inviteVoucher = json['inviteVoucher'];
    this.inviteUri = json['inviteUri'];
    this.enableAvatar = json['enableAvatar'];
    this.disableAvatar = json['disableAvatar'];
    this.withdrawThrottle = json['withdrawThrottle'];
    this.withdrawRatio = json['withdrawRatio'];
    this.fc3dFee = json['fc3dFee'];
    this.fc3dVoucher = json['fc3dVoucher'];
    this.pl3Fee = json['pl3Fee'];
    this.pl3Voucher = json['pl3Voucher'];
    this.ssqFee = json['ssqFee'];
    this.ssqVoucher = json['ssqVoucher'];
    this.dltFee = json['dltFee'];
    this.dltVoucher = json['dltVoucher'];
    this.qlcFee = json['qlcFee'];
    this.qlcVoucher = json['qlcVoucher'];
    this.every = json['every'];
    this.series = json['series'];
    this.seriesThrottle = json['seriesThrottle'];
    this.throttle = json['throttle'];
    this.exchange = json['exchange'];
  }
}
