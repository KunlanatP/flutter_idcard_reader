import 'package:flutter_idcard_reader/models/location_model.dart';
import 'package:flutter_idcard_reader/models/people_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class IDCardDetailModel {
  String? userNationID;
  PeopleModel? personData;
  LocationModel? location;

  IDCardDetailModel({
    this.userNationID,
    this.personData,
    this.location,
  });

  factory IDCardDetailModel.fromJson(Map<String, dynamic> json) =>
      _$IDCardDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$IDCardDetailModelToJson(this);
}
