import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';

class WithDrawModel with ChangeNotifier {
  List<WithdrawInfo> _list = List();

  bool _loaded = false;

  bool _error = false;

  int _page = 1;

  int _limit = 8;

  int _total = 0;

  WithDrawModel.initialize() {
    loadWithdrawList();
  }

  ///加载提现记录
  void loadWithdrawList() {
    HttpRequest request = HttpRequest.instance();
    loaded = false;
    error = false;
    page = 1;
    request
        .getJson('/expert/withdraw/list',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        error = true;
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (total > 0) {
        list
          ..clear()
          ..addAll(
            List.of(data['data']).map((v) {
              return WithdrawInfo.fromJson(v);
            }),
          );
      }
    }).catchError((err) {
      error = true;
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        loaded = true;
      });
    });
  }

  void refresh() {
    HttpRequest request = HttpRequest.instance();
    page = 1;
    request
        .getJson('/expert/withdraw/list',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        return;
      }
      final data = result['data'];
      total = data['total'];
      if (total > 0) {
        list
          ..clear()
          ..addAll(
            List.of(data['data']).map((v) {
              return WithdrawInfo.fromJson(v);
            }),
          );
      }
    }).catchError((err) {});
  }

  void loadMore() {
    if (list.length == total) {
      return;
    }
    HttpRequest request = HttpRequest.instance();
    page = page + 1;
    request
        .getJson('/expert/withdraw/list',
            params: Map()
              ..['page'] = page
              ..['limit'] = limit)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        return;
      }
      final data = result['data'];
      list
        ..clear()
        ..addAll(
          List.of(data['data']).map((v) {
            return WithdrawInfo.fromJson(v);
          }),
        );
    }).catchError((err) {});
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

  List<WithdrawInfo> get list => _list;

  set list(List<WithdrawInfo> value) {
    _list = value;
    notifyListeners();
  }

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
    notifyListeners();
  }
}

class WithdrawInfo {
  int id;

  //提现流水号
  String seqNo;

  int userId;

  //提现消耗金币
  int withdraw;

  //提现人民币金额
  int money;

  //提现状态
  int state;

  //提现审核消息
  String message;

  //提现创建时间
  String gmtCreate;

  //提现更新时间
  String gmtModify;

  WithdrawInfo.fromJson(Map data) {
    this.id = data['id'];
    this.seqNo = data['seqNo'];
    this.userId = data['userId'];
    this.withdraw = data['withdraw'];
    this.money = data['money'];
    this.state = data['state'];
    this.message = data['message'];
    this.gmtCreate = data['gmtCreate'];
    this.gmtModify = data['gmtModify'];
  }
}
