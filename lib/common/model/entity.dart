import 'package:flutter/material.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';

@immutable
abstract class Entity extends Document {
  final String userId;
  @TimestampConverter()
  final DateTime? createdAt;
  @TimestampConverter()
  final DateTime? updatedAt;
  @TimestampConverter()
  final DateTime? deletedAt;

  const Entity({
    required super.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}
