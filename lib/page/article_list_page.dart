import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/page/webview_page.dart';
import 'package:wanandroid/res.dart';

typedef Future<BaseListModel<ArticleModel>> RequestData(int page);

//文章列表
class ArticleListPage extends StatefulWidget {
  RequestData _requestData;
  Widget head;

  ArticleListPage(this._requestData, {this.head});

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
          if (widget.head != null && index == 0)
            return widget.head;
          else
            return _itemArticle(_list[index]);
        },
        itemCount: _list.length,
      ),
      onRefresh: () async {
        doRequest(_page = 0);
      },
      onLoad: () async {
        doRequest(++_page);
      },
      firstRefresh: true,
    );
  }

  @override
  void didUpdateWidget(ArticleListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._requestData != widget._requestData) {
      _controller.callRefresh();
    }
    if (oldWidget.head != widget.head) {
      setState(() {});
    }
  }

  doRequest(int page) {
    if (widget._requestData == null) return;
    widget._requestData(page).then((value) {
      if (page == 0) {
        _page = 0;
        _list.clear();
        if (widget.head != null) _list.add(new ArticleModel());
      }
      _list.addAll(value.datas);
      int length = widget.head == null ? _list.length : (_list.length - 1);
      _controller.finishLoad(noMore: length >= value.total);
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
      child: new InkWell(
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(
            builder: (context) {
              return WebViewPage(
                model.link,
                title: model.title,
                id: model.id,
                collect: model.collect,
                originId: model.originId,
              );
            },
          )).then((value) {
            if (value) _controller.callRefresh();
          });
        },
        child: new Padding(
          padding: EdgeInsets.all(8),
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
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new Column(
                    children: <Widget>[
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
                      new Offstage(
                        offstage: model.desc == null || model.desc.isEmpty,
                        child: new Text(
                          model.desc ?? "",
                          style: new TextStyle(
                              fontSize: GlobalConfig.fontSize_content,
                              color: GlobalConfig.color_content),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: new Row(
                          children: <Widget>[
                            new Offstage(
                              offstage: model.collect == null,
                              child: new Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: new Icon(
                                  model.collect ?? false
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.redAccent,
                                  size: 15,
                                ),
                              ),
                            ),
                            new Text(
                              model.niceDate,
                              style: const TextStyle(
                                  fontSize: GlobalConfig.fontSize_mark,
                                  color: GlobalConfig.color_content),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                  new Offstage(
                    offstage:
                        model.envelopePic == null || model.envelopePic.isEmpty,
                    child: new Align(
                      alignment: Alignment.bottomRight,
                      child: new ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: new FadeInImage.assetNetwork(
                          placeholder: Res.drawer_header,
                          image: model.envelopePic,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 60,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
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
