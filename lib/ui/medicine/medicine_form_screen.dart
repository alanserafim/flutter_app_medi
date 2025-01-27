import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/dose_repository.dart';
import 'package:flutter_app_medi/data/repositories/medicine_repository.dart';
import 'package:flutter_app_medi/domain/models/medicine.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../domain/models/dose.dart';

class MedicineFormScreen extends StatefulWidget {
  const MedicineFormScreen({super.key});

  @override
  State<MedicineFormScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineFormScreen> {

  List<Dose> generateDoses(Medicine medicine){
    print("Método Generate Doses");
    int totalDoses = medicine.treatmentDuration * medicine.dailyFrequency;
    List<Dose> doses = [];
    for(int i = 0; i < totalDoses; i++){
      DateTime dateTimeDose = medicine.firstDoseTime.add(Duration(minutes: medicine.doseInterval * i ));
      doses.add(Dose(
          name: medicine.name,
          dayTime: dateTimeDose,
          dosage: medicine.dosage,
          alias: medicine.alias,
          icon:  Icons.vaccines,
          status: "NOT_TAKEN"
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
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'nome do remédio'),
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
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'apelido do remédio'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: typeController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo tipo deve ser preenchido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'tipo do remédio'),
                            style: TextStyle(fontSize: 20),
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
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Frequência semanal'),
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
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'frequência diária'),
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
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'intervalo entre as doses'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: firstDoseTimeController,
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira um horário.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'horário da primeira dose'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: treatmentDurationController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo duração do tratamento deve ser preenchido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'duração do tratamento'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //salvaMedicamento
                          Medicine medicine = Medicine(
                              name: nameController.text,
                              alias: aliasController.text,
                              type: typeController.text,
                              dosage: dosageController.text,
                              dailyFrequency: int.parse(dailyFrequencyController.text),
                              weeklyFrequency: int.parse(weeklyFrequencyController.text),
                              doseInterval: int.parse(doseIntervalController.text) * 60,
                              firstDoseTime: DateFormat('dd/MM/yyyy HH:mm').parse(firstDoseTimeController.text),
                              treatmentDuration: int.parse(treatmentDurationController.text)
                          );
                          await MedicineRepository().save(medicine);
                          List doseList = generateDoses(medicine);
                          var doseExists = await DoseRepository().find(medicine.name);
                          if(doseExists.isEmpty){
                            for (var dose in doseList) {
                              await DoseRepository().save(dose);
                            }
                          } else {
                            await DoseRepository().delete(medicine.name);
                            for (var dose in doseList) {
                              await DoseRepository().save(dose);
                            }
                          }
                          //gera doses
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('medicamento cadastrado com sucesso'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0147D3),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
