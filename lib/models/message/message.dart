import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  int id;
  @JsonKey(name: 'receiver')
  int receiverID;
  String message;
  @JsonKey(name: 'create_date')
  String time;
  int view;

  Message(this.id, this.receiverID, this.message, this.time, this.view);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
