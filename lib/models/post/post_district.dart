import 'package:json_annotation/json_annotation.dart';

part 'post_district.g.dart';

@JsonSerializable()
class PostDistrict {
  int id;
  String name;

  PostDistrict({
    required this.id,
    required this.name,
  });
}
