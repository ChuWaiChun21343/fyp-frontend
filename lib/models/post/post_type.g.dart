// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostType _$PostTypeFromJson(Map<String, dynamic> json) => PostType(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$PostTypeToJson(PostType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };
