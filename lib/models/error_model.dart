import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

/// Backend error response
/// ```json
/// {
///   "error": {
///     "message": "something was wrong"
///   }
/// }
/// ```
@immutable
@JsonSerializable()
class AppError {
  final ErrorMessage error;
  const AppError(this.error);

  factory AppError.fromJson(Map<String, dynamic> json) =>
      _$AppErrorFromJson(json);
  Map<String, dynamic> toJson() => _$AppErrorToJson(this);
}

@immutable
@JsonSerializable()
class ErrorMessage {
  final String message;
  const ErrorMessage(this.message);

  factory ErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ErrorMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);
}
