import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/interceptor.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/banner_model.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/model/hot_key_model.dart';
import 'package:wanandroid/model/meizi_model.dart';
import 'package:wanandroid/model/navigator_model.dart';
import 'package:wanandroid/model/tree_model.dart';
import 'package:wanandroid/model/user_model.dart';

typedef T Format<T>(dynamic element);

class Http {
  static Http _instance;
  Dio _dio;

  Http._newInstance() {
    _dio = new Dio(new BaseOptions(baseUrl: API.BASE_URL));
    _dio.interceptors.add(new HttpInterceptor());
    _dio.interceptors.add(CookieManager(CookieJar()));
    print(CookieJar().loadForRequest(Uri.parse(API.BASE_URL)));
  }

  factory Http() {
    if (_instance == null) {
      _instance = Http._newInstance();
    }
    return _instance;
  }

  //唯一gank.io的接口，用于登录的ui
  Future<List<MeiziModel>> getMeiziList() async {
    Response response = await _dio.get(API.MEIZI);
    Map map = jsonDecode(jsonEncode(response.data));
    List list = map['data'];
    return getListFormat(list, (element) => MeiziModel.fromJson(element));
  }

  //登录
  Future<UserModel> getLogin(String username, String password) async {
    Response response = await _dio.post(API.USER_LOGIN,
        queryParameters: {'username': username, 'password': password});
    return await checkResult(
        response, (element) => UserModel.fromJson(element));
  }

  //注册
  Future<UserModel> getRegister(String username, String password,
      String repassword) async {
    Response response = await _dio.post(API.USER_REGISTER,
        queryParameters: {
          'username': username,
          'password': password,
          'repassword': repassword
        });
    return await checkResult(
        response, (element) => UserModel.fromJson(element));
  }

  //体系数据
  Future<List<TreeModel>> getTreeList() async {
    Response response = await _dio.get(API.TREE);
    return await checkResult(
        response, (element) => TreeModel.fromJson(element));
  }

  //最新项目tab (首页的第二个tab)
  Future<BaseListModel<ArticleModel>> getArticleProjectList(int page) async {
    Response response = await _dio.get(
        '${API.ARTICLE_PROJECT_LIST}/$page/json');
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  //首页banner
  Future<List<BannerModel>> getBannerList() async {
    Response response = await _dio.get(API.BANNER_LIST);
    return await checkResult(
        response, (element) => BannerModel.fromJson(element));
  }

  //置顶文章
  Future<List<ArticleModel>> getArticleTop() async {
    Response response = await _dio.get(API.ARTICLE_TOP_LIST);
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  //项目分类
  Future<List<TreeModel>> getProjectTreeList() async {
    Response response = await _dio.get(API.PROJECT_TREE);
    return await checkResult(
        response, (element) => TreeModel.fromJson(element));
  }

  //项目列表数据
  Future<BaseListModel<ArticleModel>> getProjectList(int page, int id) async {
    Response response = await _dio.get(
        '${API.PROJECT_LIST}/$page/json', queryParameters: {'cid': id});
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  //导航数据
  Future<List<NavigatorModel>> getNavigatorList() async {
    Response response = await _dio.get(API.NAVIGATOR_LIST);
    return await checkResult(
        response, (element) => NavigatorModel.fromJson(element));
  }

  //搜索热词
  Future<List<HotKeyModel>> getHotKeyList() async {
    Response response = await _dio.get(API.HOT_KEY_LIST);
    return await checkResult(
        response, (element) => HotKeyModel.fromJson(element));
  }

  //文章
  Future<BaseListModel<ArticleModel>> getArticleList(int page,
      {int cid, String author}) async {
    Map<String, dynamic> map = {};
    if (cid != null)
      map['cid'] = cid;
    if (author != null && author.isNotEmpty)
      map['author'] = author;
    Response response = await _dio.get(
        '${API.ARTICLE_LIST}/$page/json', queryParameters: map);
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  //搜索
  Future<BaseListModel<ArticleModel>> getSearchList(int page,
      String keyword) async {
    Response response = await _dio.post(
        '${API.QUERY_LIST}/$page/json', queryParameters: {'k': keyword});
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  //获取公众号列表
  Future<List<TreeModel>> getWxAuthorList() async {
    Response response = await _dio.post(API.WX_ARTICLE_AUTHOR);
    return await checkResult(
        response, (element) => TreeModel.fromJson(element));
  }

  //查看某个公众号历史数据
  Future<BaseListModel<ArticleModel>> getWxArticleList(int id, int page) async {
    Response response = await _dio.get('${API.WX_ARTICLE_LIST}/$id/$page/json');
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }

  Future checkResult<T>(Response response, Format<T> format) {
    String jsonStr = jsonEncode(response.data);
    Map map = jsonDecode(jsonStr);
    if (map['errorCode'] != 0) {
      //错误　
      debugPrint("request error: ${map['errorMsg']}");
      return Future.error(new BaseModel(map['errorCode'], map['errorMsg']));
    } else if (map['data'] is List) {
      //返回list数据
      return Future.value(getListFormat(map['data'], format));
    } else {
      //返回data数据
      Map dataMap = map['data'];
      if (dataMap['datas'] != null && dataMap['datas'] is List) {
        //分页list
        return Future.value(new BaseListModel(
            dataMap['curPage'],
            getListFormat(dataMap['datas'], format),
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

  List<T> getListFormat<T>(List list, Format<T> format) {
    List<T> newList = [];
    list.forEach((element) => newList.add(format(element)));
    return newList;
  }
}
