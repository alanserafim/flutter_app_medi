class Medicine {
  String name;
  String alias;
  String type;
  String dosage;
  int weeklyFrequency;
  int dailyFrequency;
  int doseInterval;
  int treatmentDuration;
  DateTime firstDoseTime;

  Medicine({
    required this.name,
    required this.alias,
    required this.type,
    required this.dosage,
    required this.dailyFrequency,
    required this.weeklyFrequency,
    required this.doseInterval,
    required this.firstDoseTime,
    required this.treatmentDuration,
  });
}
