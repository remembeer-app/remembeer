import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/user/constants.dart';

Future<void> seedDatabase() async {
  final firestore = FirebaseFirestore.instance;
  final drinkTypeCollection = firestore.collection('drink_types');
  final batch = firestore.batch();

  final content = await rootBundle.loadString(
    'assets/seed_data/drink_types.json',
  );
  final drinkTypesJson = jsonDecode(content) as List<dynamic>;

  final seededIds = <String>{};
  for (final drinkTypeJson in drinkTypesJson) {
    final drinkType = DrinkType.fromJson(drinkTypeJson as Map<String, dynamic>);
    final docRef = drinkTypeCollection.doc(drinkType.id);

    batch.set(docRef, drinkType.toJson().withServerCreateTimestamps());
    seededIds.add(drinkType.id);
  }

  // Global drink types dropped from the seed file are soft deleted so they stop
  // showing up in the picker. Already logged drinks keep their own copy of the
  // name, category and alcohol percentage, so their history stays intact.
  final existing = await drinkTypeCollection
      .where(userIdField, isEqualTo: globalUserId)
      .get();

  for (final doc in existing.docs) {
    if (seededIds.contains(doc.id)) {
      continue;
    }

    if (doc.data()[deletedAtField] != null) {
      continue;
    }

    batch.update(
      doc.reference,
      <String, dynamic>{}.withServerDeleteTimestamps(),
    );
  }

  await batch.commit();
}
