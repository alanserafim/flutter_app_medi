import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/medicine.dart';

class MedicineDoc {
  final String id;
  final Medicine data;
  const MedicineDoc({required this.id, required this.data});
}

Map<String, dynamic> _medicineToMap(Medicine m, {bool includeCreatedAt = false}) => {
  'name': m.name,
  'alias': m.alias,
  'type': m.type,
  'dosage': m.dosage,
  'weeklyFrequency': m.weeklyFrequency,
  'dailyFrequency': m.dailyFrequency,
  'doseInterval': m.doseInterval,
  'treatmentDuration': m.treatmentDuration,
  'firstDoseTime': Timestamp.fromDate(m.firstDoseTime),
  if (includeCreatedAt) 'createdAt': FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
};


Medicine _medicineFromMap(Map<String, dynamic> map) => Medicine(
  name: map['name'] as String? ?? '',
  alias: map['alias'] as String? ?? '',
  type: map['type'] as String? ?? '',
  dosage: map['dosage'] as String? ?? '',
  weeklyFrequency: (map['weeklyFrequency'] as num?)?.toInt() ?? 0,
  dailyFrequency: (map['dailyFrequency'] as num?)?.toInt() ?? 0,
  doseInterval: (map['doseInterval'] as num?)?.toInt() ?? 0,
  treatmentDuration: (map['treatmentDuration'] as num?)?.toInt() ?? 0,
  firstDoseTime: (map['firstDoseTime'] as Timestamp?)?.toDate() ??
      DateTime.fromMillisecondsSinceEpoch(0),
);