import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class CouponExchangeModel with ChangeNotifier {
  List<CouponExchange> _records = List();

  int _total = 0;

  int _page = 1;

  int _limit = 10;

  LoadState _state = LoadState.loading;

  CouponExchangeModel.initialize() {
    initial();
  }

  void initial() {
    page = 1;
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/exc/histories',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (data['size'] > 0) {
        records
          ..clear()
          ..addAll(
              List.of(data['data']).map((v) => CouponExchange.fromJson(v)));
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  void loadMore() {
    if (records.length == total) {
      return;
    }
    page = page + 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/exc/histories',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        EasyLoading.showToast('加载出错');
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (data['size'] > 0) {
        records
          ..addAll(
              List.of(data['data']).map((v) => CouponExchange.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载出错');
    });
  }

  void refresh() {
    page = 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/exc/histories',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        EasyLoading.showToast('加载错误');
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (data['size'] > 0) {
        records
          ..clear()
          ..addAll(
              List.of(data['data']).map((v) => CouponExchange.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载错误');
    });
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  List<CouponExchange> get records => _records;

  set records(List<CouponExchange> value) {
    _records = value;
    notifyListeners();
  }

  int get total => _total;

  set total(int value) {
    _total = value;
    notifyListeners();
  }

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
    notifyListeners();
  }

  int get page => _page;

  set page(int value) {
    _page = value;
    notifyListeners();
  }
}

class CouponExchange {
  int id;

  int userId;

  //兑换的代金券数量
  int voucher;

  //消耗的积分数量
  int coupon;

  //时间戳
  String timestamp;

  CouponExchange.fromJson(Map data) {
    this.id = data['id'];
    this.userId = data['userId'];
    this.voucher = data['voucher'];
    this.coupon = data['coupon'];
    this.timestamp = data['timestamp'];
  }
}
