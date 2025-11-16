import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_medi/authentication/services/auth_service.dart';
import 'package:flutter_app_medi/data/repositories/firestore/dose_doc.dart';
import 'package:flutter_svg/svg.dart';
import '../user/user_screen.dart';
import 'components/medicine_card.dart';

class ScheduleBaseScreen extends StatefulWidget {
  final User user;
  const ScheduleBaseScreen({super.key, required this.user});

  @override
  State<ScheduleBaseScreen> createState() => _ScheduleBaseScreenState();
}

class _ScheduleBaseScreenState extends State<ScheduleBaseScreen> {
  String _selectedFilter = "ALL";
  int _selectedIndex = 0;
  AuthService authService = AuthService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<DoseDoc> _items = [];
  bool _loading = true;
  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserScreen(user: widget.user),
            ),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user.displayName!;
    final firstName = name.split(' ')[0];

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
                Text("Bem vindo, $firstName", style: TextStyle(fontSize: 22)),
                IconButton(
                  onPressed: () {
                    _reloadOnce();
                  },
                  icon: Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    authService.signOut();
                    Navigator.pushNamed(context, '/');
                  },
                  icon: Icon(Icons.exit_to_app_rounded),
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
            Expanded(child: _buildContent()),
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

  Widget _buildContent() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Carregando'),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

    final items = List<DoseDoc>.from(_items);
    items.sort((a, b) => a.data.dayTime.compareTo(b.data.dayTime));
    final filteredItems =
        items.where((dose) {
          if (_selectedFilter == "ALL") return true;
          return dose.data.status == _selectedFilter;
        }).toList();

    if (filteredItems.isEmpty) {
      return Center(child: Text('Nenhum medicamento corresponde ao filtro.'));
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (BuildContext context, int index) {
        final DoseDoc dose = filteredItems[index];
        return MedicineCard(
          id: dose.id,
          name: dose.data.name,
          time: dose.data.dayTime,
          dosage: dose.data.dosage,
          description: dose.data.alias,
          icon: dose.data.icon,
          status: dose.data.status,
        );
      },
    );
  }

  setupListeners() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await _subscription?.cancel();

    _subscription = firestore
        .collection(uid)
        .doc('data')
        .collection('doses')
        .snapshots()
        .listen((querySnapshot) async {
          try {
            final list = await DoseService().findAll();
            setState(() {
              _items = list;
              _loading = false;
            });
          } catch (e, st) {
            debugPrint('Erro ao carregar doses: $e\n$st');
            setState(() {
              _items = [];
              _loading = false;
            });
          }
        });
  }

  void _reloadOnce() async {
    setState(() {
      _loading = true;
    });
    try {
      final list = await DoseService().findAll();
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _items = [];
        _loading = false;
      });
    }
  }
}
