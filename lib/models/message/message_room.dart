import 'package:json_annotation/json_annotation.dart';

part 'message_room.g.dart';

@JsonSerializable()
class MessageRoom {
  int id;
  @JsonKey(name: 'post_id')
  int postID;
  int creator;
  int receiver;
  @JsonKey(name: 'message')
  String latestMessage;
  int lastMessageUserID;
  @JsonKey(name: 'create_date')
  String time;
  int userID;
  String name;
  int view;

  MessageRoom(
      this.id,
      this.postID,
      this.creator,
      this.receiver,
      this.latestMessage,
      this.lastMessageUserID,
      this.time,
      this.userID,
      this.name,
      this.view);

  factory MessageRoom.fromJson(Map<String, dynamic> json) =>
      _$MessageRoomFromJson(json);

  Map<String, dynamic> toJson() => _$MessageRoomToJson(this);
}
