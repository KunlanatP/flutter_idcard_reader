import 'package:json_annotation/json_annotation.dart';

part 'query_model.g.dart';

@JsonSerializable()
class QueryModelImage {
  String? user;
  String? people;

  QueryModelImage({
    this.user,
    this.people,
  });

  factory QueryModelImage.fromJson(Map<String, dynamic> json) =>
      _$QueryModelImageFromJson(json);
  Map<String, dynamic> toJson() => _$QueryModelImageToJson(this);
}
