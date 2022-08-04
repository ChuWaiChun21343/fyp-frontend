import 'package:json_annotation/json_annotation.dart';

part 'post_type.g.dart';

@JsonSerializable()
class PostType {
  final int id;
  final String name;
  @JsonKey(defaultValue: "")
  final String url;
  @JsonKey(ignore: true)
  bool selected;

  PostType(
      {required this.id,
      required this.name,
      this.url = "",
      this.selected = false});

  factory PostType.fromJson(Map<String, dynamic> json) =>
      _$PostTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PostTypeToJson(this);
}
