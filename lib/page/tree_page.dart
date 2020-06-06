import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/tree_model.dart';
import 'package:wanandroid/page/article_scaffod_page.dart';
import 'package:wanandroid/util/util.dart';

//体系
class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  List _list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("体系"),
      ),
      body: new EasyRefresh(
        child: new ListView.builder(
          padding: new EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return _item(_list[index]);
          },
          itemCount: _list.length,
        ),
        onRefresh: () async {
          Http().getTreeList().then((value) {
            _list.clear();
            _list.addAll(value);
          }).whenComplete(() => setState(() {}));
        },
        firstRefresh: true,
      ),
    );
  }

  Widget _item(TreeModel model) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.symmetric(vertical: 10),
          child: new Text(
            model.name,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        new Wrap(
          spacing: 10,
          children: model.children
              .map((element) => new ActionChip(
                    backgroundColor: getRandomColor(a: 200),
                    elevation: 1,
                    label: new Text(
                      element.name,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                ArticleScaffoldPage(element.name, (page) {
                                  return Http()
                                      .getArticleList(page, cid: element.id);
                                }))),
                  ))
              .toList(),
        )
      ],
    );
  }
}
