import 'package:json_annotation/json_annotation.dart';

part 'notification_message.g.dart';

@JsonSerializable()
class NotificationMessage {
  int id;
  @JsonKey(name: "create_date")
  String postDate;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String content;
  int view;

  NotificationMessage({
    required this.id,
    required this.postDate,
    required this.title,
    required this.content,
    required this.view
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) =>
      _$NotificationMessageFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMessageToJson(this);
}
