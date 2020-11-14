import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/http_request.dart';
import 'package:lottery_app/components/load_state.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_upgrade/r_upgrade.dart';

class AppInfoModel with ChangeNotifier {
  ///应用包信息
  PackInfo _packInfo;

  ///应用信息
  AppInfo _appInfo;

  ///加载状态
  LoadState _state = LoadState.loading;

  ///应用是否升级
  int _shouldUpgrade = 0;

  AppInfoModel.initialize() {
    loadData();
  }

  void loadData() {
    HttpRequest request = HttpRequest.instance();
    request.getJson('/app').then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        state = LoadState.error;
        return;
      }
      if (result['data'] == null) {
        state = LoadState.error;
        return;
      }
      appInfo = AppInfo.fromJson(result['data']);
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        packInfo = PackInfo()
          ..appName = packageInfo.appName
          ..packageNo = packageInfo.packageName
          ..version = packageInfo.version
          ..buildNo = packageInfo.buildNumber;
        shouldUpgrade = appInfo.version.compareTo(packInfo.version);
        state = LoadState.success;
        if (shouldUpgrade > 0) {
          upgrade();
        }
      });
    }).catchError((error) {
      state = LoadState.error;
    });
  }

  Future<bool> canReadStorage() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (status == PermissionStatus.granted) {
      return true;
    }
    var result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void upgrade() async {
    if (!await canReadStorage()) {
      return;
    }
    RUpgrade.upgrade(
      appInfo.resource,
      fileName: 'app-release.apk',
      isAutoRequestInstall: true,
      notificationStyle: NotificationStyle.speechAndPlanTime,
    );
  }

  void checkUpgrade() {
    if (shouldUpgrade <= 0) {
      EasyLoading.showToast('您使用的是最新版本哦');
      return;
    }
    upgrade();
  }

  int get shouldUpgrade => _shouldUpgrade;

  set shouldUpgrade(int value) {
    _shouldUpgrade = value;
    notifyListeners();
  }

  PackInfo get packInfo => _packInfo;

  set packInfo(PackInfo value) {
    _packInfo = value;
    notifyListeners();
  }

  AppInfo get appInfo => _appInfo;

  set appInfo(AppInfo value) {
    _appInfo = value;
    notifyListeners();
  }

  LoadState get state => _state;

  set state(LoadState value) {
    _state = value;
    notifyListeners();
  }
}

class AppInfo {
  int id;

  //应用标识
  String seq;

  //应用名称
  String name;

  //应用版本信息
  String version;

  //应用升级内容
  String upgrade;

  //应用下载地址
  String resource;

  //应用所属公司
  String corp;

  //联系电话
  String telephone;

  //描述信息
  String remark;

  //更新时间
  String gmtCreate;

  AppInfo.fromJson(Map data) {
    this.id = data['id'];
    this.seq = data['seq'];
    this.name = data['name'];
    this.version = data['version'];
    this.upgrade = data['upgrade'];
    this.resource = data['resource'];
    this.corp = data['corp'];
    this.telephone = data['telephone'];
    this.remark = data['remark'];
    this.gmtCreate = data['gmtCreate'];
  }
}

class PackInfo {
  //应用名称
  String appName;

  //应用包名
  String packageNo;

  //应用版本
  String version;

  //应用构建编号
  String buildNo;
}
