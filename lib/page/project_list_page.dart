import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/widget/article_item_widget.dart';

//项目-列表
class ProjectListPage extends StatefulWidget {
  int _id;

  ProjectListPage(this._id);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleModel> _list = [];
  int _page = GlobalConfig.PAGE_START;
  EasyRefreshController _controller;
  final int _maxCachedPageNum = 3;
  int _cachedPageNum = 0;

  @override
  void initState() {
    super.initState();
    _controller = new EasyRefreshController();
    _controller.finishLoad(noMore: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new EasyRefresh(
      child: ListView.builder(
        padding: new EdgeInsets.symmetric(vertical: 5),
        itemBuilder: (context, index) {
          return itemArticle(_list[index]);
        },
        itemCount: _list.length,
      ),
      controller: _controller,
      onRefresh: () async {
        getProjectList(_page = 0);
      },
      onLoad: () async {
        getProjectList(_page++);
      },
      firstRefresh: true,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => _keepAlive();

  bool _keepAlive() {
    if (_cachedPageNum < _maxCachedPageNum) {
      _cachedPageNum++;
      return true;
    } else {
      return false;
    }
  }

  getProjectList(int page) {
    Http().getProjectList(page, widget._id).then((value) {
      if (page == 0) _list.clear();
      _list.addAll(value.datas);
      _controller.finishLoad(noMore: _list.length >= value.total);
    }).then((value) => setState(() {}));
  }
}
