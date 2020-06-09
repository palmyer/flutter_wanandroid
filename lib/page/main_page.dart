import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

import 'package:wanandroid/page/home_page.dart';
import 'package:wanandroid/page/login_page.dart';
import 'package:wanandroid/page/navigator_page.dart';
import 'package:wanandroid/page/project_page.dart';
import 'package:wanandroid/page/tree_tab_page.dart';
import 'package:wanandroid/res.dart';

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
          icon: new Icon(Icons.favorite_border), title: new Text("收藏")),
    ];
    _listPage = [
      new HomePage(_key),
      new ProjectPage(),
      new NavigatorPage(), //体验不好，在想想办法
      new TreeTabPage(),
      new HomePage(_key),
    ];
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
      child: new ListView(
        padding: EdgeInsets.zero,
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
                        onTap: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new LoginPage())),
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
                        'data',
                        style: new TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
          new Text("data"),
          new Text("data"),
          new Text("data"),
          new Text("data"),
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
