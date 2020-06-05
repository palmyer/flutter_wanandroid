import 'package:flutter/material.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/page/article_list_page.dart';

typedef Future<BaseListModel<ArticleModel>> RequestData(int page);

class ArticleScaffoldPage extends StatefulWidget {
  String _title;
  RequestData _requestData;

  ArticleScaffoldPage(this._title, this._requestData);

  @override
  _ArticleScaffoldPageState createState() => _ArticleScaffoldPageState();
}

class _ArticleScaffoldPageState extends State<ArticleScaffoldPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget._title),
      ),
      body: new ArticleListPage(widget._requestData),
      backgroundColor: Colors.white70,
    );
  }
}
