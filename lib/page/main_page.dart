import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:wanandroid/common/constant.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/page/article_scaffod_page.dart';

import 'package:wanandroid/page/home_page.dart';
import 'package:wanandroid/page/login_page.dart';
import 'package:wanandroid/page/navigator_page.dart';
import 'package:wanandroid/page/project_page.dart';
import 'package:wanandroid/page/tree_tab_page.dart';
import 'package:wanandroid/page/wx_article_page.dart';
import 'package:wanandroid/res.dart';
import 'package:wanandroid/util/pref_util.dart';

//主页
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<BottomNavigationBarItem> _listItem;
  List _listPage;
  GlobalKey<ScaffoldState> _key;
  String _name = "";

  @override
  void initState() {
    super.initState();
    EasyRefresh.defaultHeader = MaterialHeader();
    EasyRefresh.defaultFooter = MaterialFooter();
    _key = new GlobalKey<ScaffoldState>();
    _listItem = [
      new BottomNavigationBarItem(
          icon: new Icon(Icons.home), title: new Text("首页")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.folder_open), title: new Text("项目")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.navigation), title: new Text("导航")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.sort), title: new Text("体系")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.message), title: new Text("公众号")),
    ];
    _listPage = [
      new HomePage(_key),
      new ProjectPage(),
      new NavigatorPage(), //体验不好，在想想办法
      new TreeTabPage(),
      new WxArticlePage()
    ];
    setName();
  }

  setName() async {
    _name = await PrefUtil.getString(Constant.USER_NAME);
    _name ??= "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      drawer: getDrawer(),
      body: _listPage[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        items: _listItem,
        currentIndex: _currentIndex,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget getDrawer() {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new DrawerHeader(
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage(Res.drawer_header), fit: BoxFit.cover),
              ),
//              padding: EdgeInsets.zero,
              child: new Align(
                alignment: Alignment.topLeft,
                child: new Column(
                  children: <Widget>[
//                    new Expanded(child: new SizedBox()),
                    new InkWell(
                        onTap: () async {
                          bool success = await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new LoginPage()));
                          print("success: $success");
                          if (success ?? false) setName();
                        },
                        child: new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.white60),
                            shape: BoxShape.circle,
                          ),
                          width: 100,
                          height: 100,
                          child: new ClipOval(
                            child: new Image.asset(Res.drawer_header),
                          ),
                        )),
                    new Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: new Text(
                        _name,
                        style: new TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
          new InkWell(
            onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ArticleScaffoldPage(
                  "我的收藏",
                  (page) => Http().getCollectList(page),
                ),
              ),
            ),
            child: new ListTile(
              leading: new Icon(Icons.favorite),
              title: new Text("我的收藏"),
            ),
          ),
          new InkWell(
            onTap: () =>() => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ArticleScaffoldPage(
                  "我的分享",
                      (page) => Http().(page),
                ),
              ),
            ),
            child: new ListTile(
              leading: new Icon(Icons.share),
              title: new Text("我的分享"),
            ),
          ),
          new InkWell(
            onTap: () {},
            child: new ListTile(
              leading: new Icon(Icons.supervisor_account),
              title: new Text("广场列表"),
            ),
          ),
          new InkWell(
            onTap: () {},
            child: new ListTile(
              leading: new Icon(Icons.score),
              title: new Text("我的积分"),
            ),
          ),
          new InkWell(
            onTap: () {},
            child: new ListTile(
              leading: new Icon(Icons.history),
              title: new Text("浏览历史"),
            ),
          ),
          new InkWell(
            onTap: () {
              new SnackBar(content: new Text("设置"));
            },
            child: new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text("设置"),
            ),
          ),
          new Expanded(
              child: new Align(
            alignment: Alignment.bottomLeft,
            child: new InkWell(
              onTap: () {
                Http().getLogout().then((value) => setState(() {
                      _name = "";
                      PrefUtil.setString(Constant.USER_NAME, "");
                      PrefUtil.setString(Constant.PASSWORD, "");
                    }));
              },
              child: new ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: new Text("退出登录"),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget drawChild() {
    return new Container(
      child: new Text("data"),
    );
  }
}
