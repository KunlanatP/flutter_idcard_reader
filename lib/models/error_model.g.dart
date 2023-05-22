// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppError _$AppErrorFromJson(Map<String, dynamic> json) => AppError(
      ErrorMessage.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppErrorToJson(AppError instance) => <String, dynamic>{
      'error': instance.error,
    };

ErrorMessage _$ErrorMessageFromJson(Map<String, dynamic> json) => ErrorMessage(
      json['message'] as String,
    );

Map<String, dynamic> _$ErrorMessageToJson(ErrorMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
