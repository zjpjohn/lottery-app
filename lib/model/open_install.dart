import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';

typedef Handler(String code, String channel);

class OpenInstallModel with ChangeNotifier {
  ///openInstall
  ///
  OpeninstallFlutterPlugin _openinstallPlugin;

  OpenInstallModel.initialize() {
    initPlatform();
  }

  Future initPlatform() async {
    _openinstallPlugin = OpeninstallFlutterPlugin();
    _openinstallPlugin.init(_wakeupHandler);
  }

  Future _wakeupHandler(Map<String, dynamic> data) async {}

  void installHandler({@required Handler handler}) {
    _openinstallPlugin.install((Map<String, dynamic> data) async {
      String code, channel = '3';
      if (data['bindData'] != null && data['bindData'] != '') {
        Map<String, dynamic> params = jsonDecode(data['bindData']);
        code = params['code'] != null ? params['code'] : null;
        channel = params['channel'] != null ? params['channel'] : '3';
      }
      handler(code, channel);
    });
  }

  void reportRegister() {
    _openinstallPlugin.reportRegister();
  }

  void reportEffect({@required String point}) {
    _openinstallPlugin.reportEffectPoint(point, 1);
  }

  OpeninstallFlutterPlugin get openinstallPlugin => _openinstallPlugin;

  set openinstallPlugin(OpeninstallFlutterPlugin value) {
    _openinstallPlugin = value;
    notifyListeners();
  }
}
