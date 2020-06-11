import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/common/global_config.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/model/base_model.dart';
import 'package:wanandroid/model/rank_model.dart';

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<RankModel> _list = [];
  int _page = 1;
  EasyRefreshController _controller;
  ScrollController _scrollController;
  RankModel _randModel;
  GlobalKey _key;
  GlobalKey _keyBottom;
  bool _offstage = false;
  double _dy;
  int _index;

  @override
  void initState() {
    super.initState();
    _key = new GlobalKey();
    _keyBottom = new GlobalKey();
    _controller = new EasyRefreshController();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_dy == null || _dy == 0.0) {
        _dy = getDy(_keyBottom);
      }
      print("dy: $_dy");
      double _dyList = getDy(_key);
      if (_dyList == null) {
        _offstage = _scrollController.position.pixels > _index * 80;

//        _offstage = false;
      } else {
        _offstage = _dyList < _dy;
      }

      setState(() {});
    });
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
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(_list[index], index: index);
              },
              itemCount: _list.length,
            ),
            onRefresh: () async {
              doRequest(_page = 1);
//              doMyRank();
            },
            onLoad: () async {
              doRequest(++_page);
            },
            firstRefresh: true,
          )),
          new Offstage(
            offstage: _offstage,
            child: _randModel == null
                ? new Container()
                : _buildItem(_randModel, single: true),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(RankModel model, {bool single = false, int index = -1}) {
    return new Container(
      key: single ? _keyBottom : _index == index ? _key : null,
      decoration: BoxDecoration(
          color: _index == index || single ? Colors.yellow : Colors.white,
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
    if (page == 1 && _randModel == null) {
      Future.wait([
        Http().getRank(page).then((value) {
          _page = 1;
          _list.clear();
          _list.addAll(value.datas);
          _controller.finishLoad(noMore: _list.length >= value.total);
          return value;
        }),
        Http().getMyRank()
      ]).then((value) {
        BaseListModel<RankModel> list = value[0];
        List<RankModel> rankList = list.datas;
        _randModel = value[1];
        for (int i = 0; i < rankList.length; i++) {
          RankModel model = rankList[i];
          if (model.userId == _randModel.userId) {
            _index = i;
            break;
          }
        }
      }).then((value) => setState(() {}));
    } else {
      Http().getRank(page).then((value) {
        if (page == 1) {
          _page = 1;
          _list.clear();
        }
        _list.addAll(value.datas);
        _controller.finishLoad(noMore: _list.length >= value.total);
        return value;
      }).then((value) {
        for (int i = 0; i < value.datas.length; i++) {
          RankModel model = value.datas[i];
          if (model.userId == _randModel.userId) {
            _index = i;
            break;
          }
        }
      }).then((value) => setState(() {}));
    }
  }

  double getDy(GlobalKey key) {
    BuildContext buildContext = key.currentContext;
    if (buildContext == null) return null;
    RenderBox renderBox = buildContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset.dy;
  }
}
