import 'package:json_annotation/json_annotation.dart';

part 'hot_key_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class HotKeyModel {
  int id;
  String link;
  String name;
  int order;
  int visible;

  HotKeyModel(this.id, this.link, this.name, this.order, this.visible);

  factory HotKeyModel.fromJson(Map<String, dynamic> json) =>
      _$HotKeyModelFromJson(json);

  Map<String, dynamic> toJson() => _$HotKeyModelToJson(this);
}
