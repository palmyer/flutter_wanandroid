import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/page/article_list_page.dart';

enum HOME_TYPE {
  ARTICLE_LIST,
  ARTICLE_TOP,
  PROJECT_LIST,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<String> _listTitle = [];
  List<ArticleModel> _listArticle = [];
  bool _switch = true;

  @override
  void initState() {
    super.initState();
    _listTitle = ["最新博文", "最新项目"];
    _controller = new TabController(length: _listTitle.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: new Text("data"),
      ),
      body: new EasyRefresh.builder(
        builder: (context, physics, header, footer) {
          return new CustomScrollView(
            physics: physics,
            slivers: <Widget>[
              _appbar(),
              header,
              new SliverFillRemaining(
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    new ArticleListPage(_listArticle, physics),
                    Center(child: Text('Content of Profile')),
                  ],
                ),
              ),
//              footer,
            ],
          );
        },
        onRefresh: ()async{
          Http()
              .getArticleTop()
              .then((value) => _listArticle.addAll(value))
              .then((value) => setState(() {}));
        },
      ),
    );
  }

  Widget _appbar() {
    return new SliverAppBar(
      title: new Text("首页"),
      centerTitle: true,
      actions: <Widget>[
        new Center(
          child: new Text("置顶"),
        ),
        new Switch(
          value: _switch,
          onChanged: (value){

          },
        ),
      ],
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
//      flexibleSpace: new FlexibleSpaceBar(
//        title: new Text("space"),
//      ),
      bottom: new TabBar(
          controller: _controller,
          tabs: _listTitle
              .map((e) => new Tab(
                    text: e,
                  ))
              .toList()),
    );
  }

  getArticleTop() async {
    return Http()
        .getArticleTop()
        .then((value) => _listArticle.addAll(value))
        .then((value) => setState(() {}));
  }
}
