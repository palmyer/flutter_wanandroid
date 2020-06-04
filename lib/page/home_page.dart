import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/banner_model.dart';
import 'package:wanandroid/page/article_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<String> _listTitle = [];
  List<BannerModel> _listBanner = [];
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
      body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              _appbar(innerBoxIsScrolled),
            ];
          },
          body: new TabBarView(
            controller: _controller,
            children: <Widget>[
              new ArticleListPage(
                  _switch ? HOME_TYPE.ARTICLE_TOP : HOME_TYPE.ARTICLE_LIST,
                  () => getBannerList()),
              new ArticleListPage(
                  HOME_TYPE.PROJECT_LIST, () => getBannerList()),
            ],
          )),
    );
  }

  Widget _appbar(bool innerBoxIsScrolled) {
    return new SliverAppBar(
      title: new Text("首页"),
      centerTitle: true,
      forceElevated: innerBoxIsScrolled,
      actions: <Widget>[
        new Center(
          child: new Text("置顶"),
        ),
        new Switch(
          value: _switch,
          activeColor: Colors.white,
          onChanged: (value) {
            setState(() {
              _switch = value;
            });
          },
        ),
      ],
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: new FlexibleSpaceBar(
        background: new Swiper(
          itemBuilder: (context, index) {
            return new Image.network(
              _listBanner[index].imagePath,
              fit: BoxFit.cover,
            );
          },
          itemCount: _listBanner.length,
          autoplay: true,
        ),
      ),
      bottom: new TabBar(
          controller: _controller,
          tabs: _listTitle
              .map((e) => new Tab(
                    text: e,
                  ))
              .toList()),
    );
  }

  getBannerList() {
    if (_listBanner.length == 0) {
      Http()
          .getBannerList()
          .then((value) => _listBanner.addAll(value))
          .then((value) => setState(() {}));
    }
  }
}
