import 'package:flutter/material.dart';
import 'package:wanandroid/common/global_config.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(top: 50, bottom: 10),
            child: new Icon(Icons.hourglass_empty),
          ),
          new Text(
            "暂无数据",
            style: new TextStyle(
                fontSize: GlobalConfig.fontSize_content,
                color: GlobalConfig.color_content),
          ),
        ],
      ),
    );
  }
}
