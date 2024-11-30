import 'package:flutter/material.dart';
import 'package:flutter_app_medi/components/schedule_item.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Meus horários",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 150,
            child: Icon(
              Icons.medication_rounded,
              size: 128,
              color: Colors.blueAccent,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Remédios de hoje",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
          ScheduleItem("Dipirona", "1 comprimido", "09:00"),
          ScheduleItem("Losartana", "2 comprimids", "10:00"),
          ScheduleItem("Omeprazol", "1 comprimido", "13:00"),
          ScheduleItem("Losartana", "2 comprimids", "20:00"),
          ScheduleItem("Rivotril", "1 comprimids", "23:00"),
          SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
