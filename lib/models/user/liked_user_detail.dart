import 'package:json_annotation/json_annotation.dart';
part 'liked_user_detail.g.dart';

@JsonSerializable()
class LikedUserDetail {
  int postID;
  String postName;
  String createDate;
  String postType;

  LikedUserDetail(this.postID, this.postName, this.createDate, this.postType);

  factory LikedUserDetail.fromJson(Map<String, dynamic> json) =>
      _$LikedUserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LikedUserDetailToJson(this);
}
