// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'people_model.g.dart';

@JsonSerializable()
class PeopleModel {
  String? nationID;
  String? titleTH;
  String? firstnameTH;
  String? lastnameTH;
  String? titleEN;
  String? firstnameEN;
  String? lastnameEN;
  String? address;
  String? birthdate;
  String? issueDate;
  String? expireDate;
  int? gender;
  String? photo; //base64
  String? mobile;

  PeopleModel({
    this.nationID,
    this.titleTH,
    this.firstnameTH,
    this.lastnameTH,
    this.titleEN,
    this.firstnameEN,
    this.lastnameEN,
    this.address,
    this.birthdate,
    this.issueDate,
    this.expireDate,
    this.gender,
    this.photo,
    this.mobile,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) =>
      _$PeopleModelFromJson(json);
  Map<String, dynamic> toJson() => _$PeopleModelToJson(this);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nationID': nationID,
      'titleTH': titleTH,
      'firstnameTH': firstnameTH,
      'lastnameTH': lastnameTH,
      'titleEN': titleEN,
      'firstnameEN': firstnameEN,
      'lastnameEN': lastnameEN,
      'address': address,
      'birthdate': birthdate,
      'issueDate': issueDate,
      'expireDate': expireDate,
      'gender': gender,
      'photo': photo,
      'mobile': mobile,
    };
  }
}
