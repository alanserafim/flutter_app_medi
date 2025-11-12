import 'package:cloud_firestore/cloud_firestore.dart';

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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<MedicineDoc>> findAll() async {
    //print("Método findAll");
    List<MedicineDoc> medicinesList = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("medicines").get();
    for (var doc in snapshot.docs) {
      MedicineDoc medicine = MedicineDoc.fromMap(doc.data(), doc.id);
      medicinesList.add(medicine);
    }
    //print(medicinesList);
    return medicinesList;
  }

  Future<MedicineDoc> find(String id) async {
    print("Método find");
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore
            .collection("medicines")
            .where("id", isEqualTo: id)
            .get();
    MedicineDoc medicine = MedicineDoc.fromMap(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );
    print(medicine);
    return medicine;
  }

  save({required String id, required MedicineDoc medicine}) {
    print("Método save");
    firestore.collection("medicines").doc(id).set(medicine.toMap());
  }

  delete(String id) {
    print("Método delete");
    print(id);
    firestore.collection("medicines").doc(id).delete();
  }

  update(MedicineDoc medicine) {
    print("Método update");
    firestore.collection("medicines").doc(medicine.id).update(medicine.toMap());
  }
}

