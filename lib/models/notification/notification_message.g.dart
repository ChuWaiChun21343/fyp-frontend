// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMessage _$NotificationMessageFromJson(Map<String, dynamic> json) =>
    NotificationMessage(
      id: json['id'] as int,
      postDate: json['create_date'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      view: json['view'] as int,
    );

Map<String, dynamic> _$NotificationMessageToJson(
        NotificationMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'create_date': instance.postDate,
      'title': instance.title,
      'content': instance.content,
      'view': instance.view,
    };
