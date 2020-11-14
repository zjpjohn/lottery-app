import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/pay_channel_widget.dart';
import 'package:dio/dio.dart';
import 'package:tobias/tobias.dart' as tobias;

typedef PaySuccess();

class ChargeModel with ChangeNotifier {
  ///充值信息
  List<ChargeInfo> _charges = List();

  ///支付信息
  List<PayChannel> _channels = List();

  PayChannel _channel;

  ///支付金额
  ChargeInfo _charge;

  ///是否加载完成
  bool _loaded = false;

  ///是否出错
  bool _error = false;

  //支付状态
  bool _paying = false;

  ChargeModel.initialize() {
    loadChargeInfos();
  }

  void loadChargeInfos() {
    loaded = false;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/charge/level'),
      request.getJson('/pay/channels')
    ]).then((values) {
      Response<Map<String, dynamic>> chargeData = values[0];
      Response<Map<String, dynamic>> channelData = values[1];
      if (chargeData.data['status'] != 200 ||
          channelData.data['status'] != 200) {
        error = true;
        return;
      }
      charges
        ..clear()
        ..addAll(
          List.of(chargeData.data['data']).map((v) {
            ChargeInfo chargeInfo = ChargeInfo()
              ..levelId = v['levelId']
              ..name = v['name']
              ..amount = v['amount']
              ..valence = v['valence']
              ..voucher = v['voucher']
              ..priority = v['priority']
              ..timestamp = v['timestamp'];

            ///默认选中
            if (v['priority'] == 1) {
              charge = chargeInfo;
            }
            return chargeInfo;
          }),
        );
      channels
        ..clear()
        ..addAll(
          List.of(channelData.data['data']).map((v) {
            PayChannel ch = PayChannel()
              ..name = v['name']
              ..asset = 'assets/images/${v['icon']}.png'
              ..channel = v['channel']
              ..status = v['status']
              ..priority = v['priority'];
            if (ch.priority == 1) {
              channel = ch;
            }
            return ch;
          }),
        );
      error = false;
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        loaded = true;
      });
    });
  }

  void chargeAction({@required PaySuccess success}) {
    if (channel == null) {
      EasyLoading.showToast('请选择支付方式');
      return;
    }
    if (charge == null) {
      EasyLoading.showToast('请选择充值金额');
      return;
    }
    if (channel.channel == 'ali_pay') {
      aliPay(success);
    } else if (channel.channel == 'wx_pay') {
      wxPay(success);
    }
  }

  void aliPay(PaySuccess success) {
    if (paying) {
      EasyLoading.showToast('正在创建订单...');
      return;
    }
    paying = true;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/pay/unified?ch=2',
            params: Map()
              ..['product'] = charge.levelId
              ..['type'] = 1)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        EasyLoading.showToast('创建订单失败');
        paying = false;
        return;
      }
      tobias
          .aliPay(result['data']['order'],
              evn: result['data']['environment'] == 0
                  ? tobias.AliPayEvn.ONLINE
                  : tobias.AliPayEvn.SANDBOX)
          .then((value) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          paying = false;
          success();
        });
      }).catchError((error) {
        paying = false;
      });
    }).catchError((error) {
      paying = false;
      EasyLoading.showToast('支付失败');
    });
  }

  void wxPay(PaySuccess success) {
    EasyLoading.showToast('暂不支持');
  }

  PayChannel get channel => _channel;

  set channel(PayChannel value) {
    _channel = value;
    notifyListeners();
  }

  ChargeInfo get charge => _charge;

  set charge(ChargeInfo value) {
    _charge = value;
    notifyListeners();
  }

  bool get loaded => _loaded;

  set loaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  List<ChargeInfo> get charges => _charges;

  set charges(List<ChargeInfo> value) {
    _charges = value;
    notifyListeners();
  }

  List<PayChannel> get channels => _channels;

  set channels(List<PayChannel> value) {
    _channels = value;
    notifyListeners();
  }

  bool get error => _error;

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  bool get paying => _paying;

  set paying(bool value) {
    _paying = value;
    notifyListeners();
  }
}

class ChargeInfo {
  ///充值标识
  String levelId;

  ///充值名称
  String name;

  ///充值金额
  int amount;

  ///等值金币
  int valence;

  ///赠送代金券
  int voucher;

  ///默认优先
  int priority;

  ///时间戳
  String timestamp;
}
