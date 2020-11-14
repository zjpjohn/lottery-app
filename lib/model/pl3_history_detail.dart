import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class Pl3HistoryDetailModel with ChangeNotifier {
  ///专家标识
  String _masterId;

  ///历史预测详情
  HistoryDetail _detail;

  ///是否加载完成
  LoadState _state = LoadState.loading;

  Pl3HistoryDetailModel.initialize({@required String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/pl3/forecast/history',
            params: Map()..['masterId'] = masterId)
        .then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      final data = result['data'];
      if (data == null) {
        state = LoadState.empty;
        return;
      }
      detail = HistoryDetail()
        ..period = data['period']
        ..dan1 = Tools.parse(data['dan1'])
        ..dan2 = Tools.parse(data['dan2'])
        ..dan3 = Tools.parse(data['dan3'])
        ..com5 = Tools.parse(data['com5'])
        ..com6 = Tools.parse(data['com6'])
        ..com7 = Tools.parse(data['com7'])
        ..kill1 = Tools.parse(data['kill1'])
        ..kill2 = Tools.parse(data['kill2'])
        ..comb5 = Tools.segParse(data['comb5']);
      Future.delayed(const Duration(milliseconds: 300), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get masterId => _masterId;

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }

  HistoryDetail get detail => _detail;

  set detail(HistoryDetail value) {
    _detail = value;
    notifyListeners();
  }
}

class HistoryDetail {
  String period;

  List<Model> dan1;
  List<Model> dan2;
  List<Model> dan3;
  List<Model> com5;
  List<Model> com6;
  List<Model> com7;

  List<Model> kill1;
  List<Model> kill2;

  List<Model> comb3;
  List<Model> comb4;
  List<Model> comb5;
}
