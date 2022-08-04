import 'package:json_annotation/json_annotation.dart';

part 'district.g.dart';

@JsonSerializable()
class District {
  int id;
  @JsonKey(name: 'region_id')
  int regionID;
  String name;
  @JsonKey(ignore: true)
  bool selected;

  District({
    required this.id,
    required this.regionID,
    required this.name,
    this.selected = false,
  });

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}
