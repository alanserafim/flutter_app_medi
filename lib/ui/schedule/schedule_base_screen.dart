import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleBaseScreen extends StatefulWidget {
  const ScheduleBaseScreen({super.key});

  @override
  State<ScheduleBaseScreen> createState() => _ScheduleBaseScreenState();
}

class _ScheduleBaseScreenState extends State<ScheduleBaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
            MedicationCard(
              time: '10:00',
              dosage: '50 mg',
              name: 'HIDROCLOROTIAZIDA',
              description: 'Remédio de pressão',
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 16),
            MedicationCard(
              time: '14:00',
              dosage: '10 ml',
              name: 'INSULINA',
              description: 'Remédio de diabetes',
              icon: Icons.vaccines,
            ),
            const SizedBox(height: 16),
            MedicationCard(
              time: '14:00',
              dosage: '10 ml',
              name: 'DORFLEX',
              description: 'Remédio de dor de cabeça',
              icon: Icons.vaccines,
            ),
            const SizedBox(height: 16),
            MedicationCard(
              time: '14:00',
              dosage: '10 ml',
              name: 'PARACETAMOL',
              description: 'Remédio de FEBRE',
              icon: Icons.vaccines,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Minha Rotina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'Novo Medicamento',
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

class MedicationCard extends StatelessWidget {
  final String time;
  final String dosage;
  final String name;
  final String description;
  final IconData icon;

  const MedicationCard({
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
