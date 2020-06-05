import 'package:flutter/material.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/page/article_list_page.dart';

typedef Future<BaseListModel<ArticleModel>> RequestData(int page);

class ArticleScaffoldPage extends StatelessWidget {
  String _title;
  RequestData _requestData;

  ArticleScaffoldPage(this._title, this._requestData);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: new ArticleListPage(_requestData),
      backgroundColor: Colors.white70,
    );
  }
}
