import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_app/commons/http_request.dart';

class FeedbackModel with ChangeNotifier {
  ///反馈类型
  int _type = 9;

  ///反馈内容
  String _content;

  ///反馈图片
  List<String> _images = List();

  ///是否正在提交
  bool _submit = false;

  ///照片正在上传
  bool _upload = false;

  ///提交反馈信息
  void submitFeedback({Function callback}) {
    if (submit) {
      EasyLoading.showToast('正在提交');
      return;
    }
    if (content == null || content == '') {
      EasyLoading.showToast('请输入反馈内容');
      return;
    }
    submit = true;
    HttpRequest request = HttpRequest.instance();
    Map<String, dynamic> params = {
      'type': type,
      'content': content,
    };
    if (images.length > 0) {
      for (int i = 0; i < images.length; i++) {
        params['image${i + 1}'] = images[i];
      }
    }
    request.postJson('/feed/action', params: params).then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        EasyLoading.showToast('提交失败');
        submit = false;
        return;
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        EasyLoading.showToast('提交成功');
        content = null;
        images.clear();
        if (callback != null) {
          callback();
        }
        submit = false;
      });
    }).catchError((error) {
      EasyLoading.showToast('提交失败');
      submit = false;
    });
  }

  ///上传图片
  void uploadImage(PickedFile file) async {
    if (upload) {
      EasyLoading.showToast('正在上传');
      return;
    }
    upload = true;
    EasyLoading.show();
    String path = file.path;
    String name = path.substring(path.lastIndexOf('/') + 1, path.length);
    FormData data = FormData.fromMap({
      'file': await MultipartFile.fromFile(path, filename: name),
      'type': 'feedback',
    });
    HttpRequest request = HttpRequest.instance();
    request.postJson('/file/upload', data: data).then((response) {
      final result = response.data;
      if (result['status'] != 200) {
        EasyLoading.showToast('上传失败');
        return;
      }
      addImage(result['data']['url']);
    }).catchError((error) {
      EasyLoading.showToast('上传失败');
    }).whenComplete(() {
      EasyLoading.dismiss();
      upload = false;
    });
  }

  int get type => _type;

  set type(int value) {
    _type = value;
    notifyListeners();
  }

  String get content => _content;

  set content(String value) {
    _content = value;
    notifyListeners();
  }

  List<String> get images => _images;

  void addImage(String image) {
    images.add(image);
    notifyListeners();
  }

  void remove(String image) {
    images.remove(image);
    notifyListeners();
  }

  set images(List<String> value) {
    _images = value;
    notifyListeners();
  }

  bool get upload => _upload;

  set upload(bool value) {
    _upload = value;
    notifyListeners();
  }

  bool get submit => _submit;

  set submit(bool value) {
    _submit = value;
    notifyListeners();
  }
}
