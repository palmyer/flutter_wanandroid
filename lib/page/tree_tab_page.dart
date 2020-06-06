import 'package:flutter/material.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/page/navigator_list_page.dart';
import 'package:wanandroid/page/tree_list_page.dart';

//体系&导航
class TreeTabPage extends StatefulWidget {
  @override
  _TreeTabPageState createState() => _TreeTabPageState();
}

class _TreeTabPageState extends State<TreeTabPage>
    with SingleTickerProviderStateMixin {
  List _list = [];
  TabController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _list = ['体系', '导航'];
    _controller = new TabController(
        initialIndex: _index, length: _list.length, vsync: this);
    _controller.addListener(() {
      if (_index != _controller.index) {
        setState(() {
          _index = _controller.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new TabBar(
          indicatorColor: Colors.transparent,
          controller: _controller,
          isScrollable: true,
          tabs: _list
              .map((e) => new Tab(
                    child: new Text(
                      e,
                      style: const TextStyle(
                          fontSize: GlobalConfig.fontSize_title),
                    ),
                  ))
              .toList(),
        ),
        actions: <Widget>[
          new Offstage(
            offstage: _index == 1,
            child: new IconButton(icon: Icon(Icons.search), onPressed: () {}),
          )
        ],
      ),
      body: new TabBarView(
        controller: _controller,
        children: <Widget>[
          TreeListPage(),
          NavigatorListPage(),
        ],
      ),
    );
  }
}
