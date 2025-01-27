import 'package:flutter/material.dart';
import 'dart:async';

class Medicine {
  String name;
  String alias;
  String type;
  String dosage;
  int dailyFrequency;
  int treatmentDuration; // in days
  TimeOfDay firstDoseTime;

  Medicine({
    required this.name,
    required this.alias,
    required this.type,
    required this.dosage,
    required this.dailyFrequency,
    required this.treatmentDuration,
    required this.firstDoseTime,
  });
}

class MedicineReminderApp extends StatefulWidget {
  @override
  _MedicineReminderAppState createState() => _MedicineReminderAppState();
}

class _MedicineReminderAppState extends State<MedicineReminderApp> {
  final List<Medicine> _medicines = [];
  final List<Map<String, dynamic>> _reminders = [];

  void _addMedicine(Medicine medicine) {
    setState(() {
      _medicines.add(medicine);
      _generateReminders(medicine);
    });
  }

  void _generateReminders(Medicine medicine) {
    int totalDoses = medicine.dailyFrequency * medicine.treatmentDuration;
    int intervalMinutes = (24 * 60) ~/ medicine.dailyFrequency;
    TimeOfDay currentDoseTime = medicine.firstDoseTime;

    for (int i = 0; i < totalDoses; i++) {
      _reminders.add({
        'time': currentDoseTime,
        'name': medicine.name,
        'dosage': medicine.dosage,
      });

      final nextMinutes = currentDoseTime.hour * 60 + currentDoseTime.minute + intervalMinutes;
      currentDoseTime = TimeOfDay(hour: nextMinutes ~/ 60 % 24, minute: nextMinutes % 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Medicine Reminder'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  final time = reminder['time'] as TimeOfDay;

                  return MedicineCard(
                    time: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                    name: reminder['name'],
                    dosage: reminder['dosage'],
                    description: 'Take your medicine.',
                    icon: Icons.medication,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<Medicine>(
                    context: context,
                    builder: (context) => MedicineFormDialog(),
                  );

                  if (result != null) {
                    _addMedicine(result);
                  }
                },
                child: const Text('Add Medicine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String time;
  final String dosage;
  final String name;
  final String description;
  final IconData icon;

  const MedicineCard({
    super.key,
    required this.time,
    required this.dosage,
    required this.name,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF0147D3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  dosage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineFormDialog extends StatefulWidget {
  @override
  _MedicineFormDialogState createState() => _MedicineFormDialogState();
}

class _MedicineFormDialogState extends State<MedicineFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _dosage = '';
  int _dailyFrequency = 1;
  int _treatmentDuration = 1;
  TimeOfDay _firstDoseTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Medicine'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dosage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dosage';
                  }
                  return null;
                },
                onSaved: (value) => _dosage = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Daily Frequency'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _dailyFrequency = int.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Treatment Duration (days)'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _treatmentDuration = int.parse(value!),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('First Dose Time:'),
                  TextButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _firstDoseTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _firstDoseTime = pickedTime;
                        });
                      }
                    },
                    child: Text('${_firstDoseTime.hour.toString().padLeft(2, '0')}:${_firstDoseTime.minute.toString().padLeft(2, '0')}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(Medicine(
                name: _name,
                alias: '',
                type: '',
                dosage: _dosage,
                dailyFrequency: _dailyFrequency,
                treatmentDuration: _treatmentDuration,
                firstDoseTime: _firstDoseTime,
              ));
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
