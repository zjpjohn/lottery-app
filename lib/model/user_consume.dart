import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';

class UserConsumeModel with ChangeNotifier {
  List<LookConsume> _consumes = List();

  int _total = 0;

  int _page = 1;

  int _limit = 8;

  LoadState _state = LoadState.loading;

  UserConsumeModel.initialize() {
    initial();
  }

  void initial() {
    page = 1;
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/consumes',
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
        consumes
          ..clear()
          ..addAll(List.of(data['data']).map((v) => LookConsume.fromJson(v)));
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      print(error);
      state = LoadState.error;
    });
  }

  void loadMore() {
    if (consumes.length == total) {
      return;
    }
    page = page + 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/consumes',
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
        consumes
          ..addAll(List.of(data['data']).map((v) => LookConsume.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载出错');
    });
  }

  void refresh() {
    page = 1;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/user/consumes',
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
        consumes
          ..clear()
          ..addAll(List.of(data['data']).map((v) => LookConsume.fromJson(v)));
      }
    }).catchError((error) {
      EasyLoading.showToast('加载错误');
    });
  }

  List<LookConsume> get consumes => _consumes;

  set consumes(List<LookConsume> value) {
    _consumes = value;
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

class LookConsume {
  int id;

  //彩票类型
  String lottery;

  //用户id
  int userId;

  //专家标识
  String masterId;

  //专家名称
  String master;

  //专家预测期号
  String period;

  //消费金币数量
  int valence;

  //消费代金券数量
  int voucher;

  //消费时间
  String gmtCreate;

  LookConsume.fromJson(Map data) {
    this.id = data['id'];
    this.lottery = data['lottery'];
    this.userId = data['userId'];
    this.masterId = data['masterId'];
    this.master = data['master'];
    this.period = data['period'];
    this.valence = data['valence'];
    this.voucher = data['voucher'];
    this.gmtCreate = data['gmtCreate'];
  }
}
