import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/banner_model.dart';
import 'package:wanandroid/page/home_list_page.dart';

//首页
class HomePage extends StatefulWidget {
  GlobalKey<ScaffoldState> _parentKey;

  HomePage(this._parentKey);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<String> _listTitle = [];
  List<BannerModel> _listBanner = [];
  bool _switch = true;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    print("initState");
    _listTitle = ["最新博文", "最新项目"];
    _controller = new TabController(
        initialIndex: _index, length: _listTitle.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              new HomeListPage(
                  _switch ? HOME_TYPE.ARTICLE_TOP : HOME_TYPE.ARTICLE_LIST,
                  () => getBannerList()),
              new HomeListPage(
                  HOME_TYPE.PROJECT_LIST, () => getBannerList()),
            ],
          )),
    );
  }

  Widget _appbar(bool innerBoxIsScrolled) {
    return new SliverAppBar(
      leading: new FlatButton(
        onPressed: () {
          widget._parentKey.currentState.openDrawer();
        },
        child: new Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      title: new Text("首页"),
      centerTitle: true,
      forceElevated: innerBoxIsScrolled,
      actions: <Widget>[
        new Offstage(
          offstage: _index == 1,
          child: new Center(
            child: new Text("置顶"),
          ),
        ),
        new Offstage(
          offstage: _index == 1,
          child: new Switch(
            value: _switch,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _switch = value;
              });
            },
          ),
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
        indicatorSize: TabBarIndicatorSize.label,
        controller: _controller,
        tabs: _listTitle.map((e) => new Tab(text: e)).toList(),
        onTap: (value) => _index = value,
      ),
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
