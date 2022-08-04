import 'package:json_annotation/json_annotation.dart';

part 'post_settlement_type.g.dart';

@JsonSerializable()
class PostSettlementType {
  final int id;
  final String name;
  @JsonKey(ignore: true)
  bool selected;

  PostSettlementType({
    required this.id,
    required this.name,
    this.selected = false,
  });

  factory PostSettlementType.fromJson(Map<String, dynamic> json) =>
      _$PostSettlementTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PostSettlementTypeToJson(this);
}
