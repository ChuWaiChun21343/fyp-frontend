import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String name;
  String gender;
  List<String> genders;
  String age;
  String email;
  @JsonKey(name: 'create_date')
  String createDate;
  int postedNumber;
  int likedNumber;


  User(this.id, this.name, this.gender,this.genders ,this.age, this.email, this.createDate,this.postedNumber,this.likedNumber);

   factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
