import 'package:json_annotation/json_annotation.dart';

part 'project_tree_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class ProjectTreeModel {
  List children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  ProjectTreeModel(this.children, this.courseId, this.id, this.name, this.order,
      this.parentChapterId, this.userControlSetTop, this.visible);

  factory ProjectTreeModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectTreeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectTreeModelToJson(this);
}
