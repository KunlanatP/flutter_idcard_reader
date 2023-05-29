import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel {
  String? id;
  String? appId;
  @JsonKey(name: 'originName')
  String? name;
  int? size;
  String? extension;
  String? reference;

  ImageModel({
    this.id,
    this.appId,
    this.name,
    this.size,
    this.extension,
    this.reference,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}
