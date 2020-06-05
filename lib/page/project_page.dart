import 'package:flutter/material.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/project_tree_model.dart';
import 'package:wanandroid/page/project_list_page.dart';
import 'package:wanandroid/widget/empty_widget.dart';

//项目
class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  List<ProjectTreeModel> _listTab = [];
  TabController _controller;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(milliseconds: 100),
    ).then((_) {
      getTabList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("项目"),
        bottom: _tab(),
      ),
      body: _body(),
    );
  }

  Widget _tab() {
    if (_listTab.length == 0) return null;
    _controller = new TabController(length: _listTab.length, vsync: this);
    return new TabBar(
      controller: _controller,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _listTab.map((e) => new Tab(text: e.name)).toList(),
    );
  }

  Widget _body() {
    return (_listTab.length == 0 || _controller == null)
        ? EmptyWidget()
        : new TabBarView(
            controller: _controller,
            children: _listTab.map((e) => new ProjectListPage(e.id)).toList(),
          );
  }

  getTabList() {
    Http().getProjectTreeList().then((value) {
      _listTab.clear();
      _listTab.addAll(value);
    }).then((value) => setState(() {}));
  }
}
