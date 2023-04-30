// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';

class IDCardDetailModel {
  final String? userId;
  final ThaiIDCard? personData;
  final LocationModel? location;
  
  IDCardDetailModel({
    required this.userId,
    required this.personData,
    required this.location,
  });

  IDCardDetailModel copyWith({
    String? userId,
    ThaiIDCard? personData,
    LocationModel? location,
  }) {
    return IDCardDetailModel(
      userId: userId ?? this.userId,
      personData: personData ?? this.personData,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'personData': personData?.toMap(),
      'location': location?.toMap(),
    };
  }

  factory IDCardDetailModel.fromMap(Map<String, dynamic> map) {
    return IDCardDetailModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      personData: map['personData'] != null ? ThaiIDCard.fromMap(map['personData'] as Map<String,dynamic>) : null,
      location: map['location'] != null ? LocationModel.fromMap(map['location'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IDCardDetailModel.fromJson(String source) => IDCardDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'IDCardDetailModel(userId: $userId, personData: $personData, location: $location)';

  @override
  bool operator ==(covariant IDCardDetailModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.personData == personData &&
      other.location == location;
  }

  @override
  int get hashCode => userId.hashCode ^ personData.hashCode ^ location.hashCode;
}

class LocationModel {
  final double latitude;
  final double longitude;
  
  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  LocationModel copyWith({
    double? latitude,
    double? longitude,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) => LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocationModel(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
