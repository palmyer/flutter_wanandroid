import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/tree_model.dart';
import 'package:wanandroid/page/article_scaffod_page.dart';
import 'package:wanandroid/util/util.dart';

class TreeListPage extends StatefulWidget {
  @override
  _TreeListPageState createState() => _TreeListPageState();
}

class _TreeListPageState extends State<TreeListPage> {
  List _list = [];

  @override
  Widget build(BuildContext context) {
    return new EasyRefresh(
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
            style: const TextStyle(
                fontSize: GlobalConfig.fontSize_title,
                fontWeight: FontWeight.bold),
          ),
        ),
        new Wrap(
          spacing: 8,
          runSpacing: -5,
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
