import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/navigator_model.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  List<NavigatorModel> _listLeft = [];
  List<NavigatorModel> _listRight = [];
  int _selectIndex = 0;
  ItemScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ItemScrollController();
    doRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("导航"),
      ),
      body: new Row(
        children: <Widget>[
          _listViewLeft(),
          _listViewRight(),
        ],
      ),
    );
  }

  Widget _listViewLeft() {
    return new SizedBox(
      width: 100,
      child: new ListView.builder(
        itemBuilder: (context, index) {
          return new Container(
            height: 38,
            color: _selectIndex == index ? Colors.white : Colors.white54,
            child: new FlatButton(
                splashColor: Colors.white,
                onPressed: () {
                  int during = (index - _selectIndex).abs() * 200;
                  during = during < 200 ? 200 : during;
                  during = during > 2000 ? 2000 : during;
                  _controller.scrollTo(
                      index: index,
                      duration: Duration(milliseconds: during),
                      curve: Curves.easeOut);
                  setState(() {
                    _selectIndex = index;
                  });
                },
                child: new Text(
                  _listLeft[index].name,
                  style: new TextStyle(
                    fontSize: GlobalConfig.fontSize_mark,
                    color: _selectIndex == index
                        ? GlobalConfig.color_title
                        : GlobalConfig.color_content,
                  ),
                )),
          );
        },
        itemCount: _listLeft.length,
      ),
    );
  }

  Widget _listViewRight() {
    return new Expanded(
      child: new Container(
        color: Colors.white,
        child: new ScrollablePositionedList.builder(
          itemScrollController: _controller,
          itemCount: _listRight.length,
          itemBuilder: (context, index) {
            NavigatorModel model = _listRight[index];
            return new StickyHeader(
              header: new Container(
                height: 40,
                width: double.infinity,
                padding: new EdgeInsets.all(8),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: BorderSide(color: GlobalConfig.color_bg)),
                ),
                child: new Text(
                  model.name,
                  style: const TextStyle(
                      fontSize: GlobalConfig.fontSize_title,
                      color: GlobalConfig.color_content),
                ),
              ),
              content: new GridView.count(
                padding: new EdgeInsets.all(8),
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                physics: new NeverScrollableScrollPhysics(),
                children: model.articles
                    .map((e) => new Container(
                          child: new Center(
                            child: new Text(
                              e.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: GlobalConfig.fontSize_content,
                                color: GlobalConfig.color_title,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

//  Widget _itemRight(List<ArticleModel> model) {
//    if (model.top) {
//      return new Container(
//        width: double.infinity,
//        height: 40,
//        child: new Text(model.chapterName),
//      );
//    } else {
//      return new Container(
//        height: 20,
//        child: new Text(model.title),
//      );
//    }
//  }

  doRequest() {
    Http().getNavigatorList().then((value) {
      _listLeft.clear();
      _listRight.clear();
      _listLeft.addAll(value);
      _listRight.addAll(value);
//      for (NavigatorModel model in value) {
//        _listRight.add(new ArticleModel(chapterName: model.name, top: true));
//        _listRight.addAll(model.articles);
//      }
    }).then((value) => setState(() {}));
  }
}
