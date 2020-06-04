import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';

import 'package:wanandroid/page/home_page.dart';
import 'package:wanandroid/page/tree_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _controller;
  int _currentIndex = 0;
  List<BottomNavigationBarItem> _listItem;
  List _listPage;

  @override
  void initState() {
    super.initState();
//    EasyRefresh.defaultHeader = MaterialHeader();
//    EasyRefresh.defaultFooter = MaterialFooter();
    _controller = new PageController(initialPage: _currentIndex);
    _listItem = [
      new BottomNavigationBarItem(
          icon: new Icon(Icons.home), title: new Text("首页")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.folder_open), title: new Text("项目")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.search), title: new Text("搜索")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.sort), title: new Text("体系")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.favorite_border), title: new Text("收藏")),
    ];
    _listPage = [
      new HomePage(),
      new HomePage(),
      new HomePage(),
      new TreePage(),
      new HomePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
}
