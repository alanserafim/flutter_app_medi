import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {

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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o campo horário da primeira dose deve ser preenchido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'horário da primeira dose'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: treatmentDurationController,
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // some signup logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('medicamento cadastrado efetuado com sucesso'),
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
