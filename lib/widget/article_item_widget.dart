import 'package:flutter/material.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/model/article_model.dart';

Widget itemArticle(ArticleModel model) {
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