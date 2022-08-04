// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedUserDetail _$LikedUserDetailFromJson(Map<String, dynamic> json) =>
    LikedUserDetail(
      json['postID'] as int,
      json['postName'] as String,
      json['createDate'] as String,
      json['postType'] as String,
    );

Map<String, dynamic> _$LikedUserDetailToJson(LikedUserDetail instance) =>
    <String, dynamic>{
      'postID': instance.postID,
      'postName': instance.postName,
      'createDate': instance.createDate,
      'postType': instance.postType,
    };
