import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class TagModel {
  String name;
  String url;

  TagModel(this.name, this.url);

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}
