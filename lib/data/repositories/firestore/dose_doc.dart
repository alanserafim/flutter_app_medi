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
    print("Método findAll");
    List<DoseDoc> dosesList = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("doses").get();
    for (var doc in snapshot.docs) {
      DoseDoc dose = DoseDoc(id: doc.id, data: fromMap(doc.data()));
      dosesList.add(dose);
    }
    //print(dosesList);
    return dosesList;
  }

  //method findById
  Future<DoseDoc> findById(String id) async {
    print("Método findById");
    DocumentSnapshot<Map<String, dynamic>> snapshot =
      await firestore
        .collection("doses")
        .doc(id)
        .get();
    DoseDoc dose = DoseDoc(
        id: snapshot.id,
        data: fromMap(snapshot.data()!)
    );
    print(dose);
    return dose;
  }


  Future<List<DoseDoc>> findByName(String name) async {
    print("Método findAll");
    List<DoseDoc> dosesFilteredList = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore
            .collection("doses")
            .where("name", isEqualTo: name)
            .get();

    for (var doc in snapshot.docs) {
      DoseDoc dose = DoseDoc(id: doc.id, data: fromMap(doc.data()));
      dosesFilteredList.add(dose);
    }
    print(dosesFilteredList);
    return dosesFilteredList;
  }

  Future<void> deleteByName(String name) async {
    print("Método delete");
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore
            .collection("doses")
            .where("name", isEqualTo: name)
            .get();
    for (var doc in snapshot.docs) {
      await firestore.collection("doses").doc(doc.id).delete();
    }
  }

  Future<void> update(DoseDoc dose) async {
    print("Método update");
    await firestore
        .collection("doses")
        .doc(dose.id)
        .update(toMap(dose.data));
  }

  Future<DoseDoc> save(String id, Dose dose) async {
    print("Método save");
    await firestore.collection("doses").doc(id).set(toMap(dose));
    return DoseDoc(id: id, data: dose);
  }
}
