// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareModel _$ShareModelFromJson(Map<String, dynamic> json) {
  return ShareModel(
    json['coinInfo'] == null
        ? null
        : RankModel.fromJson(json['coinInfo'] as Map<String, dynamic>),
    json['shareArticles'] == null
        ? null
        : ShareList.fromJson(json['shareArticles'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ShareModelToJson(ShareModel instance) =>
    <String, dynamic>{
      'coinInfo': instance.coinInfo,
      'shareArticles': instance.shareArticles,
    };

ShareList _$ShareListFromJson(Map<String, dynamic> json) {
  return ShareList(
    json['curPage'] as int,
    (json['datas'] as List)
        ?.map((e) =>
            e == null ? null : ArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['offset'] as int,
    json['over'] as bool,
    json['pageCount'] as int,
    json['size'] as int,
    json['total'] as int,
  );
}

Map<String, dynamic> _$ShareListToJson(ShareList instance) => <String, dynamic>{
      'curPage': instance.curPage,
      'datas': instance.datas,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total,
    };
