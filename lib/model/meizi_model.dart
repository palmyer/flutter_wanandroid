import 'package:json_annotation/json_annotation.dart';

part 'meizi_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class MeiziModel {
  String _id;
  String author;
  String category;
  String createdAt;
  String desc;
  List<String> images;
  int likeCounts;
  String publishedAt;
  int starts;
  String title;
  String type;
  String url;
  int views;

  MeiziModel();

  factory MeiziModel.fromJson(Map<String, dynamic> json) =>
      _$MeiziModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeiziModelToJson(this);
}
