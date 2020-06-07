import 'package:flutter/material.dart';
import 'package:wanandroid/page/article_list_page.dart';

//文章页
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
    );
  }
}
