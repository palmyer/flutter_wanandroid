import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpInterceptor extends Interceptor {

  @override
  Future onRequest(RequestOptions options) {
    debugPrint('request: ${options.uri}');
    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }
}