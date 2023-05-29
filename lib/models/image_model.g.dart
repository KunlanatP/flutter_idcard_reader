// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => ImageModel(
      id: json['id'] as String?,
      appId: json['appId'] as String?,
      name: json['originName'] as String?,
      size: json['size'] as int?,
      extension: json['extension'] as String?,
      reference: json['reference'] as String?,
    );

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appId': instance.appId,
      'originName': instance.name,
      'size': instance.size,
      'extension': instance.extension,
      'reference': instance.reference,
    };
