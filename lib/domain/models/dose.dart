import 'package:flutter/material.dart';

class Dose {
  String name;
  DateTime dayTime;
  String dosage;
  String alias;
  IconData icon;
  String status;

  @override
  String toString() {
    return 'Dose{name: $name, dayTime: $dayTime, dosage: $dosage, alias: $alias, icon: $icon, status: $status}';
  }

  Dose({
    required this.name,
    required this.dayTime,
    required this.dosage,
    required this.alias,
    required this.icon,
    required this.status,
  });
}
