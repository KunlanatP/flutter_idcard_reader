// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      idCard: json['idCard'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      rank: json['rank'] as String?,
      affiliation: json['affiliation'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'idCard': instance.idCard,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'mobile': instance.mobile,
      'email': instance.email,
      'rank': instance.rank,
      'affiliation': instance.affiliation,
      'status': instance.status,
    };
