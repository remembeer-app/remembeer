// Base class for create DTOs that can be serialized to JSON.
// ignore_for_file: one_member_abstracts

import 'package:flutter/material.dart';

@immutable
abstract class ValueObject {
  Map<String, dynamic> toJson();
}
