import 'package:json_annotation/json_annotation.dart';

part 'rank_model.g.dart';

//flutter packages pub run build_runner build
@JsonSerializable()
class RankModel {
  int coinCount;
  int level;
  String rank;
  int userId;
  String username;

  RankModel(this.coinCount, this.level, this.rank, this.userId, this.username);

  factory RankModel.fromJson(Map<String, dynamic> json) =>
      _$RankModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankModelToJson(this);
}
