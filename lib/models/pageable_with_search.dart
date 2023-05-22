import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pageable_with_search.g.dart';

@immutable
@JsonSerializable()
class PageableWithSearch {
  final int offset;
  final int limit;
  final String search;

  const PageableWithSearch({
    required this.offset,
    required this.limit,
    required this.search,
  });

  factory PageableWithSearch.fromJson(Map<String, dynamic> json) =>
      _$PageableWithSearchFromJson(json);
  Map<String, dynamic> toJson() => _$PageableWithSearchToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageableWithSearch &&
        other.offset == offset &&
        other.limit == limit &&
        other.search == search;
  }

  @override
  int get hashCode => offset.hashCode ^ limit.hashCode ^ search.hashCode;
}

@JsonSerializable(genericArgumentFactories: true)
class Pagination<T> {
  late final T data;
  final int total;
  final int size;
  Pagination({
    required this.data,
    required this.total,
    required this.size,
  });

  factory Pagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginationFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginationToJson(this, toJsonT);
}
