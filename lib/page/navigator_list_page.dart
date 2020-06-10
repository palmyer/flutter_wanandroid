import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/navigator_model.dart';
import 'package:wanandroid/page/webview_page.dart';
import 'package:wanandroid/util/util.dart';

//导航列表
class NavigatorListPage extends StatefulWidget {
  @override
  _NavigatorListPageState createState() => _NavigatorListPageState();
}

class _NavigatorListPageState extends State<NavigatorListPage>
    with AutomaticKeepAliveClientMixin {
  List _list = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new EasyRefresh(
      child: new ListView.builder(
        padding: new EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _item(_list[index]);
        },
        itemCount: _list.length,
      ),
      onRefresh: () async {
        Http().getNavigatorList().then((value) {
          _list.clear();
          _list.addAll(value);
        }).then((value) => setState(() {}));
      },
      firstRefresh: true,
    );
  }

  Widget _item(NavigatorModel model) {
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
          children: model.articles
              .map((element) => new ActionChip(
                    backgroundColor: getRandomColor(a: 200),
                    elevation: 1,
                    label: new Text(
                      element.title,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                  element.link,
                                  title: element.chapterName,
                                  collect: element.collect,
                                ))),
                  ))
              .toList(),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
