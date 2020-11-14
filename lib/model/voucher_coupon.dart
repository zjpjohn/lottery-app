import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:dio/dio.dart';

class VoucherCouponModel with ChangeNotifier {
  ///用户代金券
  UserVoucher _voucher;

  ///用户积分
  CouponInfo _coupon;

  ///积分兑换记录
  List<ExchangeRecord> _records = List();

  ///是否加载完成
  bool _loaded = false;

  ///加载出错
  bool _error = false;

  ///是否正在执行兑换
  bool _exchanging = false;

  VoucherCouponModel.initialize() {
    loadVoucher(duration: Duration(milliseconds: 500));
  }

  void loadVoucher({
    Duration duration = const Duration(milliseconds: 300),
    Function callback,
  }) {
    HttpRequest request = HttpRequest.instance();
    Future.wait([
      request.getJson('/user/voucher/info'),
      request.getJson('/user/exc/info'),
      request.getJson('/user/exc/histories'),
    ]).then((values) {
      Response<Map<String, dynamic>> vouchers = values[0];
      Response<Map<String, dynamic>> couponInfo = values[1];
      Response<Map<String, dynamic>> exRecords = values[2];
      Future.delayed(duration, () {
        loaded = true;
        error = false;
        voucher = UserVoucher()
          ..voucher = vouchers.data['data']['voucher']
          ..coupon = vouchers.data['data']['coupon']
          ..obtain = vouchers.data['data']['obtain']
          ..consume = vouchers.data['data']['consume']
          ..timestamp = vouchers.data['data']['timestamp'];
        coupon = CouponInfo()
          ..coupon = couponInfo.data['data']['coupon']
          ..throttle = couponInfo.data['data']['throttle']
          ..exchange = couponInfo.data['data']['exchange']
          ..exCoupon = couponInfo.data['data']['exCoupon']
          ..exVoucher = couponInfo.data['data']['exVoucher'];
        if (exRecords.data['data']['data'] != null) {
          records
            ..clear()
            ..addAll(
              List.of(exRecords.data['data']['data']).map(
                (item) => ExchangeRecord()
                  ..coupon = item['coupon']
                  ..voucher = item['voucher']
                  ..timestamp = item['timestamp'],
              ),
            );
        }
      });
    }).catchError((_) {
      loaded = true;
      error = true;
    }).whenComplete(() {
      if (callback != null) {
        callback();
      }
    });
  }

  void exchangeAction({Function callback}) {
    if (exchanging) {
      EasyLoading.showToast('正在兑换');
      return;
    }
    exchanging = true;
    HttpRequest request = HttpRequest.instance();
    request.getJson('/user/exc').then((response) {
      int status = response.data['status'];
      if (status != 200) {
        EasyLoading.showToast(response.data['message']);
        exchanging = false;
        return;
      }
      loadVoucher(callback: () {
        Future.delayed(Duration(milliseconds: 500), () {
          exchanging = false;
        });
      });
    }).catchError((error) {
      EasyLoading.showToast('积分兑换失败');
      exchanging = false;
    });
  }

  UserVoucher get voucher => _voucher;

  set voucher(UserVoucher value) {
    _voucher = value;
    notifyListeners();
  }

  CouponInfo get coupon => _coupon;

  set coupon(CouponInfo value) {
    _coupon = value;
    notifyListeners();
  }

  List<ExchangeRecord> get records => _records;

  set records(List<ExchangeRecord> value) {
    _records = value;
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

  bool get exchanging => _exchanging;

  set exchanging(bool value) {
    _exchanging = value;
    notifyListeners();
  }
}

///账户代金券信息
///
class UserVoucher {
  ///当前账户代金券
  int voucher;

  //当前账户积分
  int coupon;

  ///累计获得代金券数量
  int obtain;

  ///累计消耗代金券数量
  int consume;

  ///时间戳
  String timestamp;
}

///积分信息
class CouponInfo {
  ///账户积分总额
  int coupon;

  ///兑换比例
  int exchange;

  ///兑换门槛
  int throttle;

  ///累计兑换的代金券数量
  int exVoucher;

  ///累计兑换的积分总额
  int exCoupon;
}

///积分兑换记录
class ExchangeRecord {
  ///兑换的代金券
  int voucher;

  ///兑换消耗的积分
  int coupon;

  ///兑换时间戳
  String timestamp;
}
