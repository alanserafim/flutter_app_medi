import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/sqflite/dose_repository.dart';
import 'package:flutter_app_medi/domain/models/dose.dart';
import 'package:flutter_svg/svg.dart';
import 'components/medicine_card.dart';

class ScheduleBaseScreen extends StatefulWidget {
  const ScheduleBaseScreen({super.key});

  @override
  State<ScheduleBaseScreen> createState() => _ScheduleBaseScreenState();
}

class _ScheduleBaseScreenState extends State<ScheduleBaseScreen> {
  String _selectedFilter = "ALL";
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bem vindo, usuário", style: TextStyle(fontSize: 22)),
                IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
            Center(
              child: SvgPicture.asset('assets/images/doctor.svg', height: 200),
            ),
            Text('Próximos medicamentos'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text("Todos"),
                  selected: _selectedFilter == "ALL",
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = "ALL";
                    });
                  },
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text("Tomados"),
                  selected: _selectedFilter == "TAKEN",
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = "TAKEN";
                    });
                  },
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text("Não Tomados"),
                  selected: _selectedFilter == "NOT_TAKEN",
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = "NOT_TAKEN";
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Dose>>(
                future: DoseRepository().findAll(),
                builder: (context, snapshot) {
                  List<Dose>? items = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando'),
                          ],
                        ),
                      );
                    case ConnectionState.waiting:
                      return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando'),
                          ],
                        ),
                      );
                    case ConnectionState.active:
                      return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando'),
                          ],
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasData && items != null) {
                        if (items.isNotEmpty) {
                          items.sort((a, b) => a.dayTime.compareTo(b.dayTime));
                          List<Dose> filteredItems =
                          items.where((dose) {
                            if (_selectedFilter == "ALL") return true;
                            return dose.status == _selectedFilter;
                          }).toList();
                          if (filteredItems.isNotEmpty) {
                            return ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Dose dose = filteredItems[index];
                                return MedicineCard(
                                  name: dose.name,
                                  time: dose.dayTime,
                                  dosage: dose.dosage,
                                  description: dose.alias,
                                  icon: dose.icon,
                                  status: dose.status,
                                );
                              },
                            );
                          }
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
                },
              ),
            ),
          ],
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
        ],
        currentIndex: 0,
      ),
    );
  }
}
