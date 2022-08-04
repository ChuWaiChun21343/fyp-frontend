// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostArticle _$PostArticleFromJson(Map<String, dynamic> json) => PostArticle(
      id: json['id'] as int,
      name: json['name'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      posterID: json['created_by'] as int,
      posterName: json['posterName'] as String,
      createDate: json['create_date'] as String,
      likedNumber: json['likedNumber'] as int,
      isLiked: json['isLiked'] as int? ?? 0,
      visitedNumber: json['visitedNumber'] as int? ?? 0,
      others: json['others'] as String,
      lastActionTime: json['lastActionTime'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      imagesSize: (json['imagesSize'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((e) => e as int).toList())
              .toList() ??
          [[]],
      settlementName: json['settlementName'] as String,
      settlementType: json['sTypeID'] as int,
      places:
          (json['places'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as int,
      statusName: json['statusName'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      belongTo: json['belong_to'] as int? ?? 0,
      transferTime: json['transferTime'] as String? ?? '',
    );

Map<String, dynamic> _$PostArticleToJson(PostArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'content': instance.content,
      'type': instance.type,
      'created_by': instance.posterID,
      'posterName': instance.posterName,
      'create_date': instance.createDate,
      'likedNumber': instance.likedNumber,
      'isLiked': instance.isLiked,
      'visitedNumber': instance.visitedNumber,
      'others': instance.others,
      'lastActionTime': instance.lastActionTime,
      'images': instance.images,
      'imagesSize': instance.imagesSize,
      'settlementName': instance.settlementName,
      'sTypeID': instance.settlementType,
      'places': instance.places,
      'status': instance.status,
      'statusName': instance.statusName,
      'tags': instance.tags,
      'belong_to': instance.belongTo,
      'transferTime': instance.transferTime,
    };
