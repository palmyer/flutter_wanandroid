import 'package:json_annotation/json_annotation.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/model/rank_model.dart';

part 'share_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class ShareModel {
  RankModel coinInfo;
  ShareList shareArticles;

  ShareModel(this.coinInfo, this.shareArticles);

  factory ShareModel.fromJson(Map<String, dynamic> json) =>
      _$ShareModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShareModelToJson(this);
}

@JsonSerializable()
class ShareList {
  int curPage;
  List<ArticleModel> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  ShareList(this.curPage, this.datas, this.offset, this.over, this.pageCount,
      this.size, this.total);

  factory ShareList.fromJson(Map<String, dynamic> json) => _$ShareListFromJson(json);

  Map<String, dynamic> toJson() => _$ShareListToJson(this);
}
