// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meizi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeiziModel _$MeiziModelFromJson(Map<String, dynamic> json) {
  return MeiziModel()
    ..author = json['author'] as String
    ..category = json['category'] as String
    ..createdAt = json['createdAt'] as String
    ..desc = json['desc'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList()
    ..likeCounts = json['likeCounts'] as int
    ..publishedAt = json['publishedAt'] as String
    ..starts = json['starts'] as int
    ..title = json['title'] as String
    ..type = json['type'] as String
    ..url = json['url'] as String
    ..views = json['views'] as int;
}

Map<String, dynamic> _$MeiziModelToJson(MeiziModel instance) =>
    <String, dynamic>{
      'author': instance.author,
      'category': instance.category,
      'createdAt': instance.createdAt,
      'desc': instance.desc,
      'images': instance.images,
      'likeCounts': instance.likeCounts,
      'publishedAt': instance.publishedAt,
      'starts': instance.starts,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
      'views': instance.views,
    };
