import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/dose.dart';

class DoseDoc {
  final String id;
  final Dose data;
  const DoseDoc({required this.id, required this.data});
}

Map<String, dynamic> _doseToMap(Dose d, {bool includeCreatedAt = false}) => {
  'name': d.name,
  'dayTime': Timestamp.fromDate(d.dayTime),
  'dosage': d.dosage,
  'alias': d.alias,
  'iconCodePoint': d.icon.codePoint,
  'fontFamily': d.icon.fontFamily,
  'fontPackage': d.icon.fontPackage,
  'status': d.status,
  if (includeCreatedAt) 'createdAt': FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
};


Dose _doseFromMap(Map<String, dynamic> map) => Dose(
  name: map['name'] as String? ?? '',
  dayTime: (map['dayTime'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
  dosage: map['dosage'] as String? ?? '',
  alias: map['alias'] as String? ?? '',
  icon: IconData(
    (map['iconCodePoint'] as num?)?.toInt() ?? 0,
    fontFamily: map['fontFamily'] as String?,
    fontPackage: map['fontPackage'] as String?,
  ),
  status: map['status'] as String? ?? '',
);