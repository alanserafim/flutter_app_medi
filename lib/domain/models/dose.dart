import 'package:flutter/material.dart';

class Dose {
  String name;
  DateTime dayTime;
  String dosage;
  String alias;
  IconData icon;
  String status;

  Dose({
    required this.name,
    required this.dayTime,
    required this.dosage,
    required this.alias,
    required this.icon,
    required this.status,
  });
}
