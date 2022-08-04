import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiManager {
  static final ApiManager _singleton = ApiManager._init();
  static Dio? _dio;

  static const url = 'http://127.0.0.1:8080';
  //static const url = 'http://10.0.2.2:8080';
  static const baseUrl = url + '/api';

  static const defaultHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static ApiManager getInstance() {
    return _singleton;
  }

  factory ApiManager() {
    return _singleton;
  }

  ApiManager._init() {
    _dio = Dio();
    _dio!.options.headers = defaultHeader;
    _dio!.options.connectTimeout = 350000;
    _dio!.options.receiveTimeout = 350000;
    // _dio!.options.connectTimeout = 1000;
    // _dio!.options.receiveTimeout = 1000;
    /// interceptors for token management
    _dio!.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        response.data!['statusCode'] = response.statusCode;
        return handler.next(response);
      }, onError: (DioError e, handler) {
        // if(e.response!.statusCode == 400){
        //   return handler.resolve(e.response!.data);
        // }
        return handler.next(e);
      }),
    );
  }


  String getImagePath() {
    return '$url/file/';
  }

  String getPDFPath() {
    return '$url/pdf/';
  }

  String getStockIOPath(){
    return "http://127.0.0.1:8081";
  }

  Future<Map<String, dynamic>?> get(
    String url, {
    String baseUrl = baseUrl,
    Map<String, dynamic>? params,
    String? token,
  }) async {
    Response<Map<String, dynamic>> response;

    if (null != params) {
      response = await _dio!.get(
        baseUrl + url,
        queryParameters: params,
        options: Options(
          headers: token == null
              ? null
              : {
                  'authorization': 'Bearer $token',
                  Headers.acceptHeader: 'application/json',
                  Headers.contentTypeHeader: 'application/json',
                },
        ),
      );
    } else {
      response = await _dio!.get(
        baseUrl + url,
        options: Options(
          headers: token == null
              ? null
              : {
                  'authorization': 'Bearer $token',
                  Headers.acceptHeader: 'application/json',
                  Headers.contentTypeHeader: 'application/json',
                },
        ),
      );
    }
    response.data!['statusCode'] = response.statusCode;
    return response.data;
  }

  Future<Map<String, dynamic>?> post(
    String url, {
    String baseUrl = baseUrl,
    Map<String, dynamic>? formDataMap,
    String? token,
  }) async {
    Response<Map<String, dynamic>> response;
    FormData formData = FormData();

    if (formDataMap == null) {
      response = await _dio!.post(
        baseUrl + url,
        data: formData,
        options: Options(
          headers: token == null
              ? null
              : {
                  'authorization': 'Bearer $token',
                  Headers.acceptHeader: 'application/json',
                  Headers.contentTypeHeader: 'application/json',
                },
        ),
      );
    } else {
      formData = FormData.fromMap(formDataMap);
      debugPrint('formDataMap: ${formDataMap.values.toString()}');
      response = await _dio!.post(
        baseUrl + url,
        data: formData,
        options: Options(
          headers: token == null
              ? null
              : {
                  'authorization': 'Bearer $token',
                  Headers.acceptHeader: 'application/json',
                  Headers.contentTypeHeader: 'application/json',
                },
        ),
      );
    }
    return response.data;
  }

  Future<Map<String, dynamic>?> put(
    String url, {
    String baseUrl = baseUrl,
    Map<String, dynamic>? formDataMap,
    String? token,
  }) async {
    Response<Map<String, dynamic>> response;
    FormData formData = FormData();

    if (formDataMap == null) {
      response = await _dio!.put(
        baseUrl + url,
        data: formData,
        options: Options(
          headers: token == null
              ? null
              : {
                  'authorization': 'Bearer $token',
                  Headers.acceptHeader: 'application/json',
                  Headers.contentTypeHeader: 'application/json',
                },
        ),
      );
    } else {
      formData = FormData.fromMap(formDataMap);
      response = await _dio!.put(
        baseUrl + url,
        data: formData,
        options: Options(
          headers: token == null
              ? null
              : {
                  'authorization': 'Bearer $token',
                  Headers.acceptHeader: 'application/json',
                  Headers.contentTypeHeader: 'application/json',
                },
        ),
      );
    }

    /// success
    return response.data;
  }
}
