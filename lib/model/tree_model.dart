import 'package:json_annotation/json_annotation.dart';

part 'tree_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class TreeModel {
  List<TreeModel> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  TreeModel(this.children, this.courseId, this.id, this.name, this.order,
      this.parentChapterId, this.userControlSetTop, this.visible);

  factory TreeModel.fromJson(Map<String, dynamic> json) =>
      _$TreeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreeModelToJson(this);
}
