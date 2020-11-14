import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/pay_channel_widget.dart';
import 'package:tobias/tobias.dart' as tobias;

typedef BuySuccess();

class PackageBuyModel with ChangeNotifier {
  ///支付渠道
  List<PayChannel> _channels = List();

  ///当前选择的支付渠道
  PayChannel _channel;

  ///套餐信息
  List<VipPackage> _packages = List();

  ///当前选择的套餐
  VipPackage _vipPackage;

  String _packId;

  //数据加载状态
  bool _loaded = false;

  //数据加载出错
  bool _error = false;

  //当前支付状态
  bool _paying = false;

  PackageBuyModel.initialize(String pId) {
    packId = pId;
    loadPackageInfo();
  }

  void loadPackageInfo() {
    loaded = false;
    error = false;
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/mar/packs'),
      request.getJson('/pay/channels'),
    ]).then((values) {
      Response<Map<String, dynamic>> packResp = values[0];
      Response<Map<String, dynamic>> channelResp = values[1];
      if (packResp.data['status'] != 200 || channelResp.data['status'] != 200) {
        error = true;
        return;
      }
      packages
        ..clear()
        ..addAll(
          List.of(packResp.data['data']).map((v) {
            VipPackage pack = VipPackage()
              ..id = v['id']
              ..name = v['name']
              ..type = v['type']
              ..packId = v['packId']
              ..price = v['price']
              ..discount = v['discount']
              ..desc = v['desc']
              ..expire = v['expire'];
            if (pack.packId == packId) {
              vipPackage = pack;
            }
            return pack;
          }),
        );
      channels
        ..clear()
        ..addAll(List.of(channelResp.data['data']).map((v) {
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
        }));
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        loaded = true;
      });
    });
  }

  void buyPackageAction({@required BuySuccess success}) {
    if (channel == null) {
      EasyLoading.showToast('请选择支付方式');
      return;
    }
    if (vipPackage == null) {
      EasyLoading.showToast('请选择购买套餐');
      return;
    }
    if (channel.channel == 'ali_pay') {
      aliPay(success);
    } else if (channel.channel == 'wx_pay') {
      wxPay(success);
    }
  }

  void aliPay(BuySuccess success) {
    if (paying) {
      EasyLoading.showToast('正在创建订单...');
      return;
    }
    paying = true;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/pay/unified?ch=2',
            params: Map()
              ..['product'] = vipPackage.packId
              ..['type'] = 2)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        EasyLoading.showToast('预下单失败');
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

  void wxPay(BuySuccess success) {
    EasyLoading.showToast('暂不支持');
  }

  String get packId => _packId;

  set packId(String value) {
    _packId = value;
    notifyListeners();
  }

  List<VipPackage> get packages => _packages;

  set packages(List<VipPackage> value) {
    _packages = value;
    notifyListeners();
  }

  List<PayChannel> get channels => _channels;

  set channels(List<PayChannel> value) {
    _channels = value;
    notifyListeners();
  }

  PayChannel get channel => _channel;

  set channel(PayChannel value) {
    _channel = value;
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

  VipPackage get vipPackage => _vipPackage;

  set vipPackage(VipPackage value) {
    _vipPackage = value;
    notifyListeners();
  }

  bool get paying => _paying;

  set paying(bool value) {
    _paying = value;
    notifyListeners();
  }
}

class VipPackage {
  int id;

  ///套餐标识
  String packId;

  ///vip套餐类型
  String type;

  ///vip套餐名称
  String name;

  ///套餐描述
  String desc;

  ///套餐价格
  double price;

  ///套餐优惠价格
  double discount;

  ///套餐有效期
  int expire;
}
