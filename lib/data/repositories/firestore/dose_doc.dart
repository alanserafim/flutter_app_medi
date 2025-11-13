import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/dose.dart';

class DoseDoc {
  final String id;
  final Dose data;
  const DoseDoc({required this.id, required this.data});

  @override
  String toString() {
    return 'DoseDoc{id: $id, data: $data}';
  }
}

Map<String, dynamic> toMap(Dose d) => {
  'name': d.name,
  'dayTime': Timestamp.fromDate(d.dayTime),
  'dosage': d.dosage,
  'alias': d.alias,
  'icon': d.icon.toString(),
  'status': d.status,
};

Dose fromMap(Map<String, dynamic> map) => Dose(
  name: map['name'] as String? ?? '',
  dayTime:
      (map['dayTime'] as Timestamp?)?.toDate() ??
      DateTime.fromMillisecondsSinceEpoch(0),
  dosage: map['dosage'] as String? ?? '',
  alias: map['alias'] as String? ?? '',
  icon: Icons.vaccines,
  status: map['status'] as String? ?? '',
);

class DoseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<DoseDoc>> findAll() async {
    debugPrint("metodo DoseService.findAll");
    try {
      final snapshot = await firestore.collection("doses").get();
      return snapshot.docs.map((doc) {
        return DoseDoc(id: doc.id, data: fromMap(doc.data()));
      }).toList();
    } on FirebaseException catch (e) {
      debugPrint("Firebase error in findAll: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error in findAll: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<DoseDoc> findById(String id) async {
    debugPrint("metodo DoseService.findById");
    try {
      final snapshot = await firestore.collection("doses").doc(id).get();
      if (!snapshot.exists) {
        throw Exception("Dose não encontrada com id: $id");
      }
      return DoseDoc(
        id: snapshot.id,
        data: fromMap(snapshot.data()!),
      );
    } on FirebaseException catch (e) {
      debugPrint("Firebase error in findById: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error in findById: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<List<DoseDoc>> findByName(String name) async {
    debugPrint("método DoseService.findByName");
    try {
      final snapshot = await firestore
          .collection("doses")
          .where("name", isEqualTo: name)
          .get();
      return snapshot.docs.map((doc) {
        return DoseDoc(id: doc.id, data: fromMap(doc.data()));
      }).toList();
    } on FirebaseException catch (e) {
      debugPrint("Firebase error in findByName: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error in findByName: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> deleteByName(String name) async {
    debugPrint("método DoseService.deleteByName");
    try {
      final snapshot = await firestore
          .collection("doses")
          .where("name", isEqualTo: name)
          .get();

      for (var doc in snapshot.docs) {
        await firestore.collection("doses").doc(doc.id).delete();
      }
    } on FirebaseException catch (e) {
      debugPrint("Firebase error in deleteByName: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error in deleteByName: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> update(DoseDoc dose) async {
    debugPrint("método DoseService.update");
    try {
      await firestore
          .collection("doses")
          .doc(dose.id)
          .update(toMap(dose.data));
    } on FirebaseException catch (e) {
      debugPrint("Firebase error in update: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error in update: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<DoseDoc> save(String id, Dose dose) async {
    debugPrint("método DoseService.save");
    try {
      await firestore.collection("doses").doc(id).set(toMap(dose));
      return DoseDoc(id: id, data: dose);
    } on FirebaseException catch (e) {
      debugPrint("Firebase error in save: '${e.message}'");
      rethrow;
    } catch (e, stack) {
      debugPrint("Unexpected error in save: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

}
