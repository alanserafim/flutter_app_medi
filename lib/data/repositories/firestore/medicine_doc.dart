import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicineDoc {
  String id;
  String name;
  String alias;
  String type;
  String dosage;
  int weeklyFrequency;
  int dailyFrequency;
  int doseInterval;
  int treatmentDuration;
  DateTime firstDoseTime;

  MedicineDoc({
    required this.id,
    required this.name,
    required this.alias,
    required this.type,
    required this.dosage,
    required this.weeklyFrequency,
    required this.dailyFrequency,
    required this.doseInterval,
    required this.treatmentDuration,
    required this.firstDoseTime,
  });

  MedicineDoc.fromMap(Map<String, dynamic> map, this.id)
    : name = map["name"] as String? ?? '',
      alias = map["alias"] as String? ?? '',
      type = map["type"] as String? ?? '',
      dosage = map["dosage"] as String? ?? '',
      weeklyFrequency = (map['weeklyFrequency'] as num?)?.toInt() ?? 0,
      dailyFrequency = (map['dailyFrequency'] as num?)?.toInt() ?? 0,
      doseInterval = (map['doseInterval'] as num?)?.toInt() ?? 0,
      treatmentDuration = (map['treatmentDuration'] as num?)?.toInt() ?? 0,
      firstDoseTime =
          (map['firstDoseTime'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'type': type,
      'dosage': dosage,
      'weeklyFrequency': weeklyFrequency,
      'dailyFrequency': dailyFrequency,
      'doseInterval': doseInterval,
      'treatmentDuration': treatmentDuration,
      'firstDoseTime': firstDoseTime,
    };
  }

  @override
  String toString() {
    return 'MedicineDoc{id: $id, name: $name, alias: $alias, type: $type, dosage: $dosage, weeklyFrequency: $weeklyFrequency, dailyFrequency: $dailyFrequency, doseInterval: $doseInterval, treatmentDuration: $treatmentDuration, firstDoseTime: $firstDoseTime}';
  }
}

class MedicineDocService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<MedicineDoc>> findAll() async {
    debugPrint('metodo MedicineDocService.findAll');
    try {
      final snapshot = await firestore
          .collection(uid)
          .doc('data')
          .collection("medicines")
          .get();
      return snapshot.docs.map((doc) {
        return MedicineDoc.fromMap(doc.data(), doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      debugPrint('Firebase error while fetching medicines: \'${e.message}\'');
      rethrow;
    } catch (e, stack) {
      debugPrint('Unexpected error while fetching medicines: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<MedicineDoc> find(String id) async {
    debugPrint('metodo MedicineDocService.find');
    try {
      final snapshot =
          await firestore
              .collection(uid)
              .doc('data')
              .collection("medicines")
              .where("id", isEqualTo: id)
              .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Nenhum medicamento encontrado com o id: $id");
      }
      final doc = snapshot.docs.first;
      return MedicineDoc.fromMap(doc.data(), doc.id);
    } on FirebaseException catch (e) {
      debugPrint("Firebase error while fetching medicine: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error while fetching medicine: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> save({required String id, required MedicineDoc medicine}) async {
    debugPrint('metodo MedicineDocService.save');
    try {
      await firestore
          .collection(uid)
          .doc('data')
          .collection("medicines")
          .doc(id)
          .set(medicine.toMap());
    } on FirebaseException catch (e) {
      debugPrint("Firebase error while saving medicine: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error while saving medicine: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    debugPrint('metodo MedicineDocService.delete');
    try {
      await firestore
          .collection(uid)
          .doc('data')
          .collection("medicines")
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      debugPrint("Firebase error while deleting medicine: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error while deleting medicine: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> update(MedicineDoc medicine) async {
    debugPrint('metodo MedicineDocService.update');
    try {
      await firestore
          .collection(uid)
          .doc('data')
          .collection("medicines")
          .doc(medicine.id)
          .update(medicine.toMap());
    } on FirebaseException catch (e) {
      debugPrint("Firebase error while updating medicine: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error while updating medicine: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }
}
