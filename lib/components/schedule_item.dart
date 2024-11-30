import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  final String nome;
  final String dosagem;
  final String horario;

  const ScheduleItem(this.nome, this.dosagem, this.horario, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.image, size: 90),
                    Column(
                      children: [
                        Text(
                          nome,
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                        Text(
                          dosagem,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_rounded,
                                color: Colors.blueAccent,
                              ),
                              Text(horario, textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
