// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel<T> _$LoginModelFromJson<T>(Map<String, dynamic> json) =>
    LoginModel<T>(
      idcard: json['idcard'] as String?,
      mobile: json['mobile'] as String?,
    );

Map<String, dynamic> _$LoginModelToJson<T>(LoginModel<T> instance) =>
    <String, dynamic>{
      'idcard': instance.idcard,
      'mobile': instance.mobile,
    };
