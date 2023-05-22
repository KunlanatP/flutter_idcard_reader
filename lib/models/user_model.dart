// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? idCard;
  String? firstname;
  String? lastname;
  String? mobile;
  String? email;
  String? rank;
  String? affiliation;
  String? status;

  UserModel({
    this.id,
    this.idCard,
    this.firstname,
    this.lastname,
    this.mobile,
    this.email,
    this.rank,
    this.affiliation,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
