import 'package:flutter/material.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/hot_key_model.dart';
import 'package:wanandroid/page/article_list_page.dart';

enum search_type {
  keyword,
  author,
}

//搜索
//TODO 热词功能
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map _map = {search_type.keyword: '关键字', search_type.author: '作者'};
  var _initValue = search_type.keyword;
  List<HotKeyModel> _listHot = [];
  TextEditingController _controller;
  RequestData _requestData;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _requestData = getRequestData();
    doHotRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: _searchView(),
        actions: <Widget>[
          new Container(
            width: 60,
            child: new FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _requestData = getRequestData();
                  });
                },
                child: new Text(
                  "搜索",
                  style: new TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: _controller.value.text.isEmpty
          ? _hotWidget()
          : new ArticleListPage(_requestData),
    );
  }

  Widget _searchView() {
    return new Theme(
        data: ThemeData(
          primaryColor: Colors.white,
          cursorColor: Colors.pinkAccent,
        ),
        child: new TextField(
            controller: _controller,
            style: new TextStyle(color: Colors.white),
            cursorColor: Colors.pinkAccent,
            decoration: new InputDecoration(
              suffixIcon: _popMenu(),
              suffixIconConstraints: new BoxConstraints(
                maxHeight: 25,
                minWidth: 25,
              ),
              hintText: '按${_map[_initValue]}搜索',
              hintStyle: new TextStyle(color: Colors.white30),
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            onSubmitted: (value) {},
            onChanged: (val) {}));
  }

  Widget _popMenu() {
    return new SizedBox(
      width: 25,
      height: 25,
      child: new PopupMenuButton(
          padding: EdgeInsets.only(right: 8),
          child: new Icon(_initValue == search_type.keyword
              ? Icons.keyboard
              : Icons.person),
          initialValue: _initValue,
          offset: new Offset(0, _initValue == search_type.keyword ? 120 : 220),
          tooltip: "按关键字/作者搜索",
          onSelected: (value) => setState(() {
                _initValue = value;
              }),
          itemBuilder: (context) {
            return [
              new PopupMenuItem(
                child: new Text(_map[search_type.keyword]),
                value: search_type.keyword,
              ),
              new PopupMenuItem(
                child: new Text(_map[search_type.author]),
                value: search_type.author,
              ),
            ];
          }),
    );
  }

  getRequestData() {
    if (_initValue == search_type.keyword) {
      return (page) => Http().getSearchList(page, _controller.text);
    } else {
      return (page) => Http().getArticleList(page, author: _controller.text);
    }
  }

  Widget _hotWidget() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: new Wrap(
        spacing: 5,
        runSpacing: -5,
        children: _listHot
            .map((e) => new ActionChip(
                label: new Text(e.name),
                onPressed: () {
                  _controller.text = e.name;
                  setState(() {
                    _requestData = getRequestData();
                  });
                }))
            .toList(),
      ),
    );
  }

  doHotRequest() {
    Http().getHotKeyList().then((value) {
      _listHot.clear();
      _listHot.addAll(value);
    }).then((value) => setState(() {}));
  }
}
