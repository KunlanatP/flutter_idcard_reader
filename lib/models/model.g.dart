// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDCardDetailModel _$IDCardDetailModelFromJson(Map<String, dynamic> json) =>
    IDCardDetailModel(
      userNationID: json['userNationID'] as String?,
      personData: json['personData'] == null
          ? null
          : PeopleModel.fromJson(json['personData'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IDCardDetailModelToJson(IDCardDetailModel instance) =>
    <String, dynamic>{
      'userNationID': instance.userNationID,
      'personData': instance.personData,
      'location': instance.location,
    };
