import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class UserModel {
  bool admin;
  List chapterTops;
  List collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String publicName;
  String token;
  int type;
  String username;

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
