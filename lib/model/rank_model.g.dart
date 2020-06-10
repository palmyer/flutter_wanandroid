// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankModel _$RankModelFromJson(Map<String, dynamic> json) {
  return RankModel(
    json['coinCount'] as int,
    json['level'] as int,
    json['rank'] as String,
    json['userId'] as int,
    json['username'] as String,
  );
}

Map<String, dynamic> _$RankModelToJson(RankModel instance) => <String, dynamic>{
      'coinCount': instance.coinCount,
      'level': instance.level,
      'rank': instance.rank,
      'userId': instance.userId,
      'username': instance.username,
    };
