// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigatorModel _$NavigatorModelFromJson(Map<String, dynamic> json) {
  return NavigatorModel(
    articles: (json['articles'] as List)
        ?.map((e) =>
            e == null ? null : ArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    cid: json['cid'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$NavigatorModelToJson(NavigatorModel instance) =>
    <String, dynamic>{
      'articles': instance.articles,
      'cid': instance.cid,
      'name': instance.name,
    };
