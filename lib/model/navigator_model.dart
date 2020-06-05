import 'package:json_annotation/json_annotation.dart';
import 'package:wanandroid/model/article_model.dart';

part 'navigator_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class NavigatorModel {
  List<ArticleModel> articles;
  int cid;
  String name;

  NavigatorModel({this.articles, this.cid, this.name});

  factory NavigatorModel.fromJson(Map<String, dynamic> json) =>
      _$NavigatorModelFromJson(json);

  Map<String, dynamic> toJson() => _$NavigatorModelToJson(this);
}
