// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedUser _$LikedUserFromJson(Map<String, dynamic> json) => LikedUser(
      json['id'] as int,
      json['name'] as String,
      json['totalNumber'] as int,
      json['create_date'] as String,
      json['postName'] as String,
      json['postID'] as int,
    );

Map<String, dynamic> _$LikedUserToJson(LikedUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalNumber': instance.totalNumber,
      'create_date': instance.lastTime,
      'postName': instance.postName,
      'postID': instance.postID,
    };
