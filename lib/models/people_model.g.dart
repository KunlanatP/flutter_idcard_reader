// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeopleModel _$PeopleModelFromJson(Map<String, dynamic> json) => PeopleModel(
      nationID: json['nationID'] as String?,
      titleTH: json['titleTH'] as String?,
      firstnameTH: json['firstnameTH'] as String?,
      lastnameTH: json['lastnameTH'] as String?,
      titleEN: json['titleEN'] as String?,
      firstnameEN: json['firstnameEN'] as String?,
      lastnameEN: json['lastnameEN'] as String?,
      address: json['address'] as String?,
      birthdate: json['birthdate'] as String?,
      issueDate: json['issueDate'] as String?,
      expireDate: json['expireDate'] as String?,
      gender: json['gender'] as int?,
      mobile: json['mobile'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$PeopleModelToJson(PeopleModel instance) =>
    <String, dynamic>{
      'nationID': instance.nationID,
      'titleTH': instance.titleTH,
      'firstnameTH': instance.firstnameTH,
      'lastnameTH': instance.lastnameTH,
      'titleEN': instance.titleEN,
      'firstnameEN': instance.firstnameEN,
      'lastnameEN': instance.lastnameEN,
      'address': instance.address,
      'birthdate': instance.birthdate,
      'issueDate': instance.issueDate,
      'expireDate': instance.expireDate,
      'gender': instance.gender,
      'mobile': instance.mobile,
      'photo': instance.photo,
    };
