import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/rank_model.dart';

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<RankModel> _list = [];
  int _page = 1;
  EasyRefreshController _controller;
  RankModel _randModel;

  @override
  void initState() {
    super.initState();
    _controller = new EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("积分排行"),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
              child: new EasyRefresh(
            controller: _controller,
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(_list[index]);
              },
              itemCount: _list.length,
            ),
            onRefresh: () async {
              doRequest(_page = 1);
              doMyRank();
            },
            onLoad: () async {
              doRequest(++_page);
            },
            firstRefresh: true,
          )),
          _randModel == null
              ? new Container()
              : _buildItem(_randModel, single: true),
        ],
      ),
    );
  }

  Widget _buildItem(RankModel model, {bool single = false}) {
    return new Container(
      decoration: BoxDecoration(
          color: single ? Colors.yellow : Colors.white,
          border: single
              ? null
              : const Border(bottom: BorderSide(color: GlobalConfig.color_bg))),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 80,
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(right: 10),
            child: new Text(
              "${model.rank}.",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  color: Colors.grey),
            ),
          ),
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                model.username,
                style: const TextStyle(
                    fontSize: 20, color: GlobalConfig.color_title),
              ),
              new Text(
                "积分: ${model.coinCount}",
                style: const TextStyle(
                    fontSize: GlobalConfig.fontSize_mark,
                    color: GlobalConfig.color_content),
              ),
            ],
          )),
          new Text(
            "Lv  ${model.level}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: GlobalConfig.fontSize_title,
                color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }

  doRequest(int page) {
    Http().getRank(page).then((value) {
      if (page == 1) {
        _page = 1;
        _list.clear();
      }
      _list.addAll(value.datas);
      _controller.finishLoad(noMore: _list.length >= value.total);
    }).then((value) => setState(() {}));
  }

  doMyRank() {
    Http().getMyRank().then((value) => setState(() => _randModel = value));
  }
}
