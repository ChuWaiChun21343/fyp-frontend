import 'package:json_annotation/json_annotation.dart';

part 'liked_user.g.dart';

@JsonSerializable()
class LikedUser {
  int id;
  String name;
  int totalNumber;
  @JsonKey(name: "create_date")
  String lastTime;
  String postName;
  int postID;

  LikedUser(
    this.id,
    this.name,
    this.totalNumber,
    this.lastTime,
    this.postName,
    this.postID,
  );

  factory LikedUser.fromJson(Map<String, dynamic> json) =>
      _$LikedUserFromJson(json);

  Map<String, dynamic> toJson() => _$LikedUserToJson(this);
}
