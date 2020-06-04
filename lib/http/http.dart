import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/interceptor.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/model/tree_model.dart';

typedef T Format<T>(dynamic element);

class Http {
  static Http _instance;
  Dio _dio;

  Http._newInstance() {
    _dio = new Dio(new BaseOptions(baseUrl: API.BASE_URL));
    _dio.interceptors.add(new HttpInterceptor());
  }

  factory Http() {
    if (_instance == null) {
      _instance = Http._newInstance();
    }
    return _instance;
  }
  //体系数据
  Future<List<TreeModel>> getTreeList() async {
    Response response = await _dio.get(API.TREE);
    return await checkResult(
        response, (element) => TreeModel.fromJson(element));
  }
  //首页文章列表
  Future<BaseListModel<ArticleModel>> getArticleList(int page) async {
    Response response = await _dio.get('${API.ARTICLE_LIST}$page/json');
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }
  //置顶文章
  Future<List<ArticleModel>> getArticleTop() async {
    Response response = await _dio.get(API.ARTICLE_TOP);
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  Future checkResult<T>(Response response, Format<T> format) {
    String jsonStr = jsonEncode(response.data);
    debugPrint("request data: $jsonStr");
    Map map = jsonDecode(jsonStr);
    if (map['errorCode'] != 0) {
      //错误　
      debugPrint("request error: ${map['errorMsg']}");
      return Future.error(new BaseModel(map['errorCode'], map['errorMsg']));
    } else if (map['data'] is List) {
      //返回list数据
      List list = map['data'];
      List<T> valueList = [];
      list.forEach((element) => valueList.add(format(element)));
      return Future.value(valueList);
    } else {
      //返回data数据
      Map dataMap = map['data'];
      if (dataMap['datas'] != null && dataMap['datas'] is List) {
        //分页list
        return Future.value(new BaseListModel(
            dataMap['curPage'],
            dataMap['datas'],
            dataMap['offset'],
            dataMap['over'],
            dataMap['pageCount'],
            dataMap['size'],
            dataMap['total']
        ));
      } else {
        return Future.value(format(map['data']));
      }
    }
  }
}
