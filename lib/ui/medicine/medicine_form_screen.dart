import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/firestore/dose_doc.dart';
import 'package:flutter_app_medi/data/repositories/firestore/medicine_doc.dart';
import 'package:flutter_app_medi/data/repositories/sqflite/dose_repository.dart';
import 'package:flutter_app_medi/data/repositories/sqflite/medicine_repository.dart';
import 'package:flutter_app_medi/domain/models/medicine.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/dose.dart';

class MedicineFormScreen extends StatefulWidget {
  const MedicineFormScreen({super.key});

  @override
  State<MedicineFormScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineFormScreen> {
  MedicineDocService medicineService = MedicineDocService();
  DoseService doseService = DoseService();

  List<DoseDoc> generateDoses(MedicineDoc medicine) {
    print("Método Generate Doses");
    int totalDoses = medicine.treatmentDuration * medicine.dailyFrequency;
    List<DoseDoc> doses = [];
    for (int i = 0; i < totalDoses; i++) {
      DateTime dateTimeDose = medicine.firstDoseTime.add(
          Duration(minutes: medicine.doseInterval * i));
      Dose dose = Dose(
          name: medicine.name,
          dayTime: dateTimeDose,
          dosage: medicine.dosage,
          alias: medicine.alias,
          icon: Icons.vaccines,
          status: "NOT_TAKEN"
      );
      doses.add(DoseDoc(
          id: Uuid().v1(),
          data: dose
      ));
    }
    return doses;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController aliasController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController weeklyFrequencyController = TextEditingController();
  TextEditingController dailyFrequencyController = TextEditingController();
  TextEditingController doseIntervalController = TextEditingController();
  TextEditingController firstDoseTimeController = TextEditingController();
  TextEditingController treatmentDurationController = TextEditingController();

  String? _selectedValue;
  DateTime? _selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          firstDoseTimeController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Medicamento"),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: [
              SvgPicture.asset(
                'assets/images/medicine.svg',
                height: 250,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE8BB6C),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo nome do remédio deve ser preenchido';
                              }
                              if (value.length < 2) {
                                return 'O nome deve ter pelo menos 2 caracteres.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'nome do remédio'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: aliasController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo apelido do remédio deve ser preenchido';
                              }
                              if (value.length < 2) {
                                return 'O apelido deve ter pelo menos 2 caracteres.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'apelido do remédio'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Selecione uma opção',
                            ),
                            value: _selectedValue,
                            items: [
                              DropdownMenuItem(
                                value: 'comprimido',
                                child: Text('Comprimido'),
                              ),
                              DropdownMenuItem(
                                value: 'injeção',
                                child: Text('Injeção'),
                              ),
                              DropdownMenuItem(
                                value: 'solução',
                                child: Text('Solução (líquido)'),
                              ),
                              DropdownMenuItem(
                                value: 'gotas',
                                child: Text('Gotas'),
                              ),
                              DropdownMenuItem(
                                value: 'inalador',
                                child: Text('Inalador'),
                              ),
                              DropdownMenuItem(
                                value: 'pó',
                                child: Text('Pó'),
                              ),
                              DropdownMenuItem(
                                value: 'outro',
                                child: Text('Outro'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedValue =
                                    value; // Atualiza o valor selecionado
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, selecione uma opção.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: dosageController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo dosagem do remédio deve ser preenchido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'dosagem'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: weeklyFrequencyController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo frequência semanal deve ser preenchido';
                              }
                              final regex = RegExp(r'^\d+$');
                              if (!regex.hasMatch(value)) {
                                return 'Digite um valor numérico';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Frequência semanal em dias'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: dailyFrequencyController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo frequência diária deve ser preenchido';
                              }
                              final regex = RegExp(r'^\d+$');
                              if (!regex.hasMatch(value)) {
                                return 'Digite um valor numérico';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'frequência diária'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: doseIntervalController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo intervalo entre as doses deve ser preenchido';
                              }
                              final regex = RegExp(r'^\d+$');
                              if (!regex.hasMatch(value)) {
                                return 'Digite um valor numérico';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'intervalo entre as doses (minutos)'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Data e Hora da primeira dose',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDateTime(context),
                            validator: (value) {
                              if (_selectedDateTime == null) {
                                return 'Por favor, selecione uma data e hora.';
                              }
                              return null;
                            },
                            controller: firstDoseTimeController,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: treatmentDurationController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo duração do tratamento deve ser preenchido';
                              }
                              final regex = RegExp(r'^\d+$');
                              if (!regex.hasMatch(value)) {
                                return 'Digite um valor numérico';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'duração do tratamento (dias)'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String id = Uuid().v1();
                          MedicineDoc medicine = MedicineDoc(
                              id: id,
                              name: nameController.text,
                              alias: aliasController.text,
                              type: typeController.text,
                              dosage: dosageController.text,
                              dailyFrequency: int.parse(
                                  dailyFrequencyController.text),
                              weeklyFrequency: int.parse(
                                  weeklyFrequencyController.text),
                              doseInterval: int.parse(
                                  doseIntervalController.text),
                              firstDoseTime: DateFormat('dd/MM/yyyy HH:mm')
                                  .parse(firstDoseTimeController.text),
                              treatmentDuration: int.parse(
                                  treatmentDurationController.text)
                          );
                          await medicineService.save(medicine: medicine, id: id);
                          List doseList = generateDoses(medicine);
                          for (var dose in doseList) {
                            await doseService.save(dose.id, dose.data);
                          }
                          var doseExists = await doseService.findByName(
                              medicine.name);
                          if (doseExists.isEmpty) {
                            for (var dose in doseList) {
                              await doseService.save(dose.id, dose.data);
                            }
                          } else {
                            await doseService.deleteByName(medicine.name);
                            for (var dose in doseList) {
                              await doseService.save(dose.id, dose.data);
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'medicamento cadastrado com sucesso'),
                            ),
                          );
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0147D3),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}