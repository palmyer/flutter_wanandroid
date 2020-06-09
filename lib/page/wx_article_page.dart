import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/tree_model.dart';
import 'package:wanandroid/page/article_list_page.dart';
import 'package:wanandroid/util/util.dart';

class WxArticlePage extends StatefulWidget {
  @override
  _WxArticlePageState createState() => _WxArticlePageState();
}

class _WxArticlePageState extends State<WxArticlePage> {
  List<ArticleModel> _list = [];
  List<TreeModel> _listHead = [];
  int id;

  @override
  void initState() {
    super.initState();
    doRequest();
    print('int: $id');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("公众号"),
      ),
      body: new ArticleListPage((page) {
        return Http().getWxArticleList(id, page);
      }),
    );
  }

  Widget _head() {
    double width = MediaQuery.of(context).size.width;
    width = (width - 50) / 4;
    return new Container(
      height: width * 2 + 30,
      child: new GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: _listHead.map((e) => _headItem(e)).toList(),
      ),
    );
  }

  Widget _headItem(TreeModel model) {
    return new Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: getRandomColor(),
      ),
      child: new Center(
        child: new Text(
          model.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  doRequest() {
    Http().getWxAuthorList().then((value) {
      _listHead.clear();
      _listHead.addAll(value);
    }).then((value) => setState(() {}));
  }
}
