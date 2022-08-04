// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['name'] as String,
      json['gender'] as String,
      (json['genders'] as List<dynamic>).map((e) => e as String).toList(),
      json['age'] as String,
      json['email'] as String,
      json['create_date'] as String,
      json['postedNumber'] as int,
      json['likedNumber'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'genders': instance.genders,
      'age': instance.age,
      'email': instance.email,
      'create_date': instance.createDate,
      'postedNumber': instance.postedNumber,
      'likedNumber': instance.likedNumber,
    };
