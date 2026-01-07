import 'package:flutter/material.dart';

@immutable
abstract class Document {
  final String id;

  const Document({required this.id});

  Map<String, dynamic> toJson();
}
