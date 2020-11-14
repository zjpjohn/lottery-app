import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class UserOrderModel with ChangeNotifier {
  ///订单集合
  List<OrderInfo> _orders = List();

  int _total;

  ///页码
  int _page = 1;

  ///每页大小
  int _limit = 8;

  ///加载状态
  LoadState _state = LoadState.loading;

  UserOrderModel.initialize() {
    initial();
  }

  void initial() {
    page = 1;
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/order/list',
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
      if (total > 0) {
        orders
          ..clear()
          ..addAll(List.of(data['data']).map((v) => OrderInfo.fromJson(v)));
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  void loadMore() {
    if (orders.length == total) {
      return;
    }
    page = page + 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/order/list',
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
        orders..addAll(List.of(data['data']).map((v) => OrderInfo.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载出错');
    });
  }

  void refresh() {
    page = 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/order/list',
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
      if (total > 0) {
        orders
          ..clear()
          ..addAll(List.of(data['data']).map((v) => OrderInfo.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载错误');
    });
  }

  int get total => _total;

  set total(int value) {
    _total = value;
    notifyListeners();
  }

  List<OrderInfo> get orders => _orders;

  set orders(List<OrderInfo> value) {
    _orders = value;
    notifyListeners();
  }

  int get page => _page;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class OrderInfo {
  int id;

  String orderNo;

  int userId;

  int type;

  String prodId;

  double price;

  int channel;

  String desc;

  String attachment;

  int status;

  String createTime;

  String updateTime;

  OrderInfo.fromJson(Map json) {
    this.id = json['id'];
    this.orderNo = json['orderNo'];
    this.userId = json['userId'];
    this.type = json['type'];
    this.prodId = json['prodId'];
    this.price = json['price'];
    this.channel = json['channel'];
    this.desc = json['desc'];
    this.attachment = json['attachment'];
    this.status = json['status'];
    this.createTime = json['createTime'];
    this.updateTime = json['updateTime'];
  }
}
