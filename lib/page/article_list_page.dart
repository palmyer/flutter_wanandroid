import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/base_model.dart';

enum HOME_TYPE {
  ARTICLE_LIST,
  ARTICLE_TOP,
  PROJECT_LIST,
}

class ArticleListPage extends StatefulWidget {
  var _type = HOME_TYPE.ARTICLE_LIST;
  VoidCallback _callback;

  ArticleListPage(this._type, this._callback);

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  List<ArticleModel> _list = [];
  int _page = GlobalConfig.PAGE_START;
  EasyRefreshController _controller;
  int _sizeTop = 0;

  @override
  void initState() {
    super.initState();
    _controller = new EasyRefreshController();
    _controller.finishLoad(noMore: true);
  }

  @override
  Widget build(BuildContext context) {
    return new EasyRefresh(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _item(_list[index]);
        },
        itemCount: _list.length,
      ),
      controller: _controller,
      onRefresh: () async {
        widget._callback.call();
        doRequest(true);
      },
      onLoad: () async {
        doRequest(false);
      },
      firstRefresh: true,
    );
  }

  //list的item
  Widget _item(ArticleModel model) {
    return new Card(
      child: new Container(
        padding: new EdgeInsets.all(8),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //标题
            new Text(
              model.title ?? "",
              style: new TextStyle(
                  fontSize: GlobalConfig.fontSize_title,
                  color: GlobalConfig.color_title),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            //作者
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 5),
              child: new Row(
                children: <Widget>[
                  new Offstage(
                    offstage: !model.top,
                    child: _outlineTop(),
                  ),
                  new Text(
                    model.author ?? "",
                    style: new TextStyle(
                        fontSize: GlobalConfig.fontSize_content,
                        color: GlobalConfig.color_content),
                  )
                ],
              ),
            ),
            //描述
            new Text(
              model.desc ?? "",
              style: new TextStyle(
                  fontSize: GlobalConfig.fontSize_content,
                  color: GlobalConfig.color_content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  //置顶
  Widget _outlineTop() {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 2),
      margin: new EdgeInsets.only(right: 5),
      child: new Text(
        "置顶",
        style: new TextStyle(
            color: Colors.red, fontSize: GlobalConfig.fontSize_mark),
      ),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.red),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(2)),
    );
  }

  getArticleTop(int page) {
    if (page == 0) {
      Future.wait([Http().getArticleTop(), Http().getArticleList(0)])
          .then((value) {
        List<ArticleModel> listTop = value[0];
        listTop.forEach((element) => element.top = true);
        _sizeTop = listTop.length;
        BaseListModel<ArticleModel> list = value[1];
        _controller.finishLoad(noMore: list.datas.length >= list.total);
        _page = page;
        _list.clear();
        _list.addAll(listTop);
        _list.addAll(list.datas);
      }).then((value) => setState(() {}));
    } else {
      getArticleList(page);
    }
  }

  getArticleList(int page) {
    Http().getArticleList(page).then((value) {
      if (page == 0) _list.clear();
      _page = page;
      _list.addAll(value.datas);
      _controller.finishLoad(noMore: noMore(value.total));
    }).then((value) => setState(() {}));
  }

  noMore(int total) {
    int length = _list.length;
    if (widget._type == HOME_TYPE.ARTICLE_TOP) length -= _sizeTop;
    return length >= total;
  }

  getProjectList(int page) {
    Http().getArticleProjectList(page).then((value) {
      if (page == 0) _list.clear();
      _page = page;
      _list.addAll(value.datas);
      _controller.finishLoad(noMore: _list.length >= value.total);
    }).then((value) => setState(() {}));
  }

  doRequest(bool refresh) {
    if (refresh)
      _page = 0;
    else
      _page++;
    switch (widget._type) {
      case HOME_TYPE.ARTICLE_TOP:
        getArticleTop(_page);
        break;
      case HOME_TYPE.ARTICLE_LIST:
        getArticleList(_page);
        break;
      case HOME_TYPE.PROJECT_LIST:
        getProjectList(_page);
        break;
    }
  }
}
