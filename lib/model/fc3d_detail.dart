import 'package:flutter/material.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/commons/tools.dart';
import 'package:lottery_app/components/load_state.dart';

class Fc3dDetailModel with ChangeNotifier {
  String _masterId;

  Fc3dDetail _detail;

  LoadState _state = LoadState.loading;

  Fc3dDetailModel.initialize({@required String masterId}) {
    _masterId = masterId;
    loadData();
  }

  void loadData() {
    state = LoadState.loading;
    HttpRequest request = HttpRequest.instance();
    request
        .getJson('/fc3d/forecast', params: Map()..['masterId'] = masterId)
        .then((response) {
      final result = response.data;
      if (result['status'] == 5403) {
        state = LoadState.pay;
        return;
      }
      if (result['status'] == 5204) {
        state = LoadState.empty;
        return;
      }
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      final data = result['data'];
      detail = Fc3dDetail()
        ..period = data['period']
        ..dan1 = Tools.split(data['dan1'])
        ..dan2 = Tools.split(data['dan2'])
        ..dan3 = Tools.split(data['dan3'])
        ..com5 = Tools.split(data['com5'])
        ..com6 = Tools.split(data['com6'])
        ..com7 = Tools.split(data['com7'])
        ..kill1 = Tools.split(data['kill1'])
        ..kill2 = Tools.split(data['kill2'])
        ..comb5 = Tools.split(data['comb5']);
      Future.delayed(const Duration(milliseconds: 250), () {
        state = LoadState.success;
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  String get masterId => _masterId;

  Fc3dDetail get detail => _detail;

  set detail(Fc3dDetail value) {
    _detail = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class Fc3dDetail {
  String period;

  List<String> dan1;
  List<String> dan2;
  List<String> dan3;

  List<String> com5;
  List<String> com6;
  List<String> com7;

  List<String> kill1;
  List<String> kill2;

  List<String> comb3;
  List<String> comb4;
  List<String> comb5;
}
