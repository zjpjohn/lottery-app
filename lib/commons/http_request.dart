import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery_app/commons/event_center.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class HttpRequest {
  static HttpRequest _instance;
  final String _baseUrl = 'http://api.icai68.com';
  static final String GET = 'get';
  static final String POST = 'post';

  Dio _dio;
  BaseOptions _options;

  static HttpRequest instance() {
    if (_instance == null) {
      _instance = new HttpRequest();
    }
    return _instance;
  }

  HttpRequest() {
    _options = new BaseOptions(
      baseUrl: _baseUrl,
      receiveTimeout: 8000,
      connectTimeout: 6000,
    );
    _dio = new Dio(_options);
    //拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        //请求预处理
        String path = options.uri.path;
        //请求权限表处理
        if (Constant.withoutAuth[path] != 1) {
          String token = SpUtil.getString('token');
          if (token == null || token.isEmpty) {
            //终止请求
            options.cancelToken.cancel();
            eventBus.fire(UnAuthEvent());
          } else {
            Map<String, dynamic> headers = Map();
            headers['authentication'] = token;
            options.headers = headers;
          }
        }
        return options;
      }, onResponse: (Response response) {
        //返回响应数据预处理
        Headers headers = response.headers;
        String key = headers.value('sid');
        String iv = headers.value('ivr');
        if (key != null && iv != null) {
          var data = encrypt.Encrypter(encrypt.AES(
            encrypt.Key.fromBase64(key),
            mode: encrypt.AESMode.cbc,
          )).decrypt(
            encrypt.Encrypted.fromBase64(response.data['data']),
            iv: encrypt.IV.fromBase64(iv),
          );
          response.data['data'] = json.decode(data);
        }
        return response;
      }, onError: (DioError error) {
        //请求失败处理
        Response response = error.response;
        if (response != null) {
          switch (response.statusCode) {
            case 401:
              eventBus.fire(UnAuthEvent());
              break;
            case 404:
              break;
            case 500:
              break;
          }
        }
      }),
    );
  }

  Future<Response<Map<String, dynamic>>> getJson(String url,
      {Map<String, dynamic> params, Options options}) {
    return _dio.get(
      url,
      queryParameters: params,
      cancelToken: CancelToken(),
      options: options,
    );
  }

  Future<Response<Map<String, dynamic>>> postJson(String url,
      {data, Map<String, dynamic> params, Options options}) {
    return _dio.post(
      url,
      data: data,
      queryParameters: params,
      cancelToken: CancelToken(),
      options: options,
    );
  }

  void get(String url, Function success,
      {Map<String, dynamic> params, Function error, Options options}) async {
    Response response;
    try {
      if (params != null && params.isNotEmpty) {
        response = await _dio.get(url,
            queryParameters: params,
            options: options,
            cancelToken: CancelToken());
      } else {
        response = await _dio.get(url, cancelToken: CancelToken());
      }
      _response(response, success, error: error);
    } catch (e) {
      _error(error, '系统出错啦');
    }
  }

  void post(String url, Function success,
      {data,
      Map<String, dynamic> params,
      Function error,
      Options options}) async {
    Response response;
    try {
      if (params != null && params.isNotEmpty && data != null) {
        response = await _dio.post(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: CancelToken());
      } else if (data == null) {
        response = await _dio.post(url,
            queryParameters: params,
            options: options,
            cancelToken: CancelToken());
      } else if (params == null || params.isEmpty) {
        response = await _dio.post(url,
            data: data, options: options, cancelToken: CancelToken());
      } else {
        response = await _dio.post(url, cancelToken: CancelToken());
      }
      _response(response, success, error: error);
    } catch (e) {
      _error(error, '系统出错啦');
    }
  }

  void _response(Response response, Function success, {Function error}) {
    int status = response.statusCode;
    if (status != 200) {
      _error(error, '系统异常');
      return;
    }
    String result = json.encode(response.data);
    Map<String, dynamic> data = json.decode(result);
    if (data != null && data['status'] != 200) {
      _error(error, data['message']);
      return;
    }
    if (success != null) {
      success(data['data']);
    }
  }

  _error(Function callback, String error) {
    if (callback == null) {
      EasyLoading.showToast(error);
    } else {
      callback(error);
    }
  }
}
