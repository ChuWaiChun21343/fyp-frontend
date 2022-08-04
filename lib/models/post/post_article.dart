import 'package:json_annotation/json_annotation.dart';

part 'post_article.g.dart';

@JsonSerializable()
class PostArticle {
  int id;
  String name;
  String content;
  String type;
  @JsonKey(name: 'created_by')
  int posterID;
  String posterName;
  @JsonKey(name: 'create_date')
  String createDate;
  int likedNumber;
  @JsonKey(defaultValue: 0)
  int isLiked;
  @JsonKey(defaultValue: 0)
  int visitedNumber;
  String others;
  @JsonKey(defaultValue: "")
  String lastActionTime;
  List<String>? images;
  @JsonKey(defaultValue: [[]])
  List<List<int>> imagesSize;
  String settlementName;
  @JsonKey(name: 'sTypeID')
  int settlementType;
  List<String> places;
  int status;
  @JsonKey(defaultValue: "")
  String statusName;
  List<String> tags;
  @JsonKey(name: 'belong_to', defaultValue: 0)
  int belongTo;
  @JsonKey(defaultValue: "")
  String transferTime;

  PostArticle({
    required this.id,
    required this.name,
    required this.content,
    required this.type,
    required this.posterID,
    required this.posterName,
    required this.createDate,
    required this.likedNumber,
    required this.isLiked,
    required this.visitedNumber,
    required this.others,
    required this.lastActionTime,
    this.images,
    required this.imagesSize,
    required this.settlementName,
    required this.settlementType,
    required this.places,
    required this.status,
    required this.statusName,
    required this.tags,
    required this.belongTo,
    required this.transferTime
  });

  factory PostArticle.fromJson(Map<String, dynamic> json) =>
      _$PostArticleFromJson(json);

  Map<String, dynamic> toJson() => _$PostArticleToJson(this);
}
