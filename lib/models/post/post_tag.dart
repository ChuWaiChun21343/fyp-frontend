import 'package:json_annotation/json_annotation.dart';

part 'post_tag.g.dart';

@JsonSerializable()
class PostTag {
  final int id;
  final String name;
  @JsonKey(ignore: true)
  bool selected;

  PostTag({required this.id, required this.name, this.selected = false});

  factory PostTag.fromJson(Map<String, dynamic> json) =>
      _$PostTagFromJson(json);

  Map<String, dynamic> toJson() => _$PostTagToJson(this);
}
