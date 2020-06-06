import 'package:flutter/material.dart';

enum search_type {
  keyword,
  author,
}

//搜索
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
//  List _list = ['关键词', '作者'];
  Map _map = {search_type.keyword: '关键字', search_type.author: '作者'};
  var _initValue = search_type.keyword;

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
                onPressed: () {},
                child: new Text(
                  "搜索",
                  style: new TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

  Widget _searchView() {
    return new Theme(
        data: ThemeData(
          primaryColor: Colors.white,
          cursorColor: Colors.pinkAccent,
        ),
        child: new TextField(
            style: new TextStyle(color: Colors.white),
            cursorColor: Colors.pinkAccent,
//        textInputAction: TextInputAction.search,
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
            onChanged: (val) {
              print(val);
            }));
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
          onSelected: (value) => setState(() => _initValue = value),
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
  doHotRequest(){

  }
}
