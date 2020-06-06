import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/base_model.dart';

typedef Future<BaseListModel<ArticleModel>> RequestData(int page);

//文章列表
class ArticleListPage extends StatefulWidget {
  RequestData _requestData;

  ArticleListPage(this._requestData);

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleModel> _list = [];
  int _page = 0;
  EasyRefreshController _controller;
  int _maxCachedPageNum = 3; //最大缓存数量
  int _cachedPageNum = 0; //当前缓存数

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
      controller: _controller,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemArticle(_list[index]);
        },
        itemCount: _list.length,
      ),
      onRefresh: () async {
        doRequest(_page = 0);
      },
      onLoad: () async {
        doRequest(_page++);
      },
      firstRefresh: true,
    );
  }

  doRequest(int page) {
    widget._requestData(page).then((value) {
      if (page == 0) {
        _page = 0;
        _list.clear();
      }
      _list.addAll(value.datas);
      _controller.finishLoad(noMore: _list.length >= value.total);
    }).then((value) => setState(() {}));
  }

  @override
  bool get wantKeepAlive {
    if (_cachedPageNum < _maxCachedPageNum) {
      _cachedPageNum++;
      return true;
    } else {
      return false;
    }
  }

  Widget _itemArticle(ArticleModel model) {
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
}
