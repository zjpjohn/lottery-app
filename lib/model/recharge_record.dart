import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class RechargeRecordModel with ChangeNotifier {
  ///充值记录
  List<RechargeRecord> _records = List();

  ///总数
  int _total = 0;

  ///页码
  int _page = 1;

  ///每页大小
  int _limit = 8;

  ///加载状态
  LoadState _state = LoadState.loading;

  RechargeRecordModel.initialize() {
    initial();
  }

  void initial() {
    page = 1;
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/charges',
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
              List.of(data['data']).map((v) => RechargeRecord.fromJson(v)));
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
        .getJson('/user/charges',
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
              List.of(data['data']).map((v) => RechargeRecord.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载出错');
    });
  }

  void refresh() {
    page = 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/charges',
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
              List.of(data['data']).map((v) => RechargeRecord.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载错误');
    });
  }

  List<RechargeRecord> get records => _records;

  set records(List<RechargeRecord> value) {
    _records = value;
    notifyListeners();
  }

  int get total => _total;

  set total(int value) {
    _total = value;
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

class RechargeRecord {
  int id;

  String sequence;

  int userId;

  int amount;

  int valence;

  int voucher;

  String timestamp;

  RechargeRecord.fromJson(Map data) {
    this.id = data['id'];
    this.sequence = data['sequence'];
    this.userId = data['userId'];
    this.amount = data['amount'];
    this.valence = data['valence'];
    this.voucher = data['voucher'];
    this.timestamp = data['timestamp'];
  }
}
