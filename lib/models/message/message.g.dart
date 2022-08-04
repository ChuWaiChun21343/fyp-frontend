// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['id'] as int,
      json['receiver'] as int,
      json['message'] as String,
      json['create_date'] as String,
      json['view'] as int,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'receiver': instance.receiverID,
      'message': instance.message,
      'create_date': instance.time,
      'view': instance.view,
    };
