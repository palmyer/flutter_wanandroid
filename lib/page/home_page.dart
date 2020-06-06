import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/banner_model.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/page/article_list_page.dart';

//首页
class HomePage extends StatefulWidget {
  GlobalKey<ScaffoldState> _parentKey;

  HomePage(this._parentKey);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  List<String> _listTitle = [];
  List<BannerModel> _listBanner = [];
  bool _switch = true;
  int _index = 0;
  int _lengthTop = 0;

  @override
  void initState() {
    super.initState();
    _listTitle = ["最新博文", "最新项目"];
    _controller = new TabController(
        initialIndex: _index, length: _listTitle.length, vsync: this);
    getBannerList();
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
              new ArticleListPage((page) => doRequest(page)),
              new ArticleListPage((page) => doRequest(page)),
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
        onTap: (value) => setState(() => _index = value),
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

  doRequest(page) {
    if (_index == 0) {
      //文章列表
      if (_switch) {
        //打开置顶
        if (page == 0) {
          //合并：置顶+列表
          return Future.wait([Http().getArticleTop(), Http().getArticleList(0)])
              .then((value) {
            List<ArticleModel> _listTop = [];
            _listTop.addAll(value[0]);
            _listTop.forEach((element) => element.top = true);
            _lengthTop = _listTop.length;
            BaseListModel<ArticleModel> _list = value[1];
            _list.datas.insertAll(0, _listTop);
            _list.total += _lengthTop;
            return _list;
          });
        } else {
          return Http().getArticleList(page).then((value) {
            if (_switch) value.total += _lengthTop;
          });
        }
      } else {
        //关闭置顶
        return Http().getArticleList(page);
      }
    } else if (_index == 1) {
      //项目列表
      return Http().getArticleProjectList(page);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
