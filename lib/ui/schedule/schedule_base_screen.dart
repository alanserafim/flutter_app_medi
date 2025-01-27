import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/dose_repository.dart';
import 'package:flutter_app_medi/domain/models/dose.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/models/medicine.dart';
import 'components/medicine_card.dart';

class ScheduleBaseScreen extends StatefulWidget {
  const ScheduleBaseScreen({super.key});

  @override
  State<ScheduleBaseScreen> createState() => _ScheduleBaseScreenState();
}

class _ScheduleBaseScreenState extends State<ScheduleBaseScreen> {
  final List<Medicine> _medicines = [];
  final List<Map<String, dynamic>> _doses = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/schedule');
          break;
        case 1:
          Navigator.pushNamed(context, '/medication');
          break;
        case 2:
          Navigator.pushNamed(context, '/user');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              "Bem vindo, usuário",
              style: TextStyle(
                  fontSize: 22
              ),

            ),
            Center(
              child: SvgPicture.asset(
                'assets/images/doctor.svg',
                height: 200,
              ),
            ),
            const Text('Próximos medicamentos'),
            Expanded(
              child: FutureBuilder<List<Dose>>(
                  future: DoseRepository().findAll(),
                  builder: (context, snapshot){
                    List<Dose>? items = snapshot.data;
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: Column(
                            children: [CircularProgressIndicator(), Text('Carregando')],
                          ),
                        );
                      case ConnectionState.waiting:
                        return Center(
                          child: Column(
                            children: [CircularProgressIndicator(), Text('Carregando')],
                          ),
                        );
                      case ConnectionState.active:
                        return Center(
                          child: Column(
                            children: [CircularProgressIndicator(), Text('Carregando')],
                          ),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasData && items != null) {
                          if (items.isNotEmpty) {
                            items.sort((a, b) => a.dayTime.compareTo(b.dayTime));
                            return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Dose dose = items[index];
                                return MedicineCard(
                                      name: dose.name,
                                      time: dose.dayTime,
                                      dosage: dose.dosage,
                                      description: dose.alias,
                                      icon: dose.icon,
                                    );
                              },
                            );
                          }
                        }
                    }
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          Icon(Icons.error_outline, size: 64),
                          Text(
                            'Não há nenhum medicamento cadastrado',
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Minha Rotina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'Medicamentos',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
        ],
        currentIndex: 0,
      ),
    );
  }
}


/*
body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
                "Bem vindo, usuário",
              style: TextStyle(
                fontSize: 22
              ),

            ),
            Center(
              child: SvgPicture.asset(
                'assets/images/doctor.svg',
                height: 300,
              ),
            ),
            const Text('Próximos medicamentos'),
            const Text(
              '12/01/2025',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),


MedicineCard(
              time: '10:00',
              dosage: '50 mg',
              name: 'HIDROCLOROTIAZIDA',
              description: 'Remédio de pressão',
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 16),
            MedicineCard(
              time: '14:00',
              dosage: '10 ml',
              name: 'INSULINA',
              description: 'Remédio de diabetes',
              icon: Icons.vaccines,
            ),
            const SizedBox(height: 16),
            MedicineCard(
              time: '14:00',
              dosage: '10 ml',
              name: 'DORFLEX',
              description: 'Remédio de dor de cabeça',
              icon: Icons.vaccines,
            ),
            const SizedBox(height: 16),
            MedicineCard(
              time: '14:00',
              dosage: '10 ml',
              name: 'PARACETAMOL',
              description: 'Remédio de FEBRE',
              icon: Icons.vaccines,
            ),
 */
