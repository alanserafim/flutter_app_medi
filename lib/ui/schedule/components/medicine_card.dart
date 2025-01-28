import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/dose_repository.dart';

class MedicineCard extends StatefulWidget {
  final DateTime time;
  final String dosage;
  final String name;
  final String description;
  final IconData icon;
  final String status;

  const MedicineCard({
    super.key,
    required this.time,
    required this.dosage,
    required this.name,
    required this.description,
    required this.icon,
    required this.status,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  bool _isTaken = false;

  @override
  void initState() {
    super.initState();
    if (widget.status == "TAKEN") {
      setState(() {
        _isTaken = true;
      });
    } else {
      setState(() {
        _isTaken = false;
      });
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tomar medicamento'),
          content: const Text('Você tomou sua dose deste medicamento?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (widget.status == "NOT_TAKEN") {
                  var dose = await DoseRepository().findByNameAndDayTime(
                    widget.name,
                    widget.time,
                  );
                  print(dose.toString());
                  dose[0].status = "TAKEN";
                  await DoseRepository().update(dose[0]);
                  setState(() {
                    _isTaken = true;
                  });
                  Navigator.pop(context);
                } else {
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Tomar'),
            ),
            TextButton(
              onPressed: () async {
                if (widget.status == "TAKEN") {
                  var dose = await DoseRepository().findByNameAndDayTime(
                    widget.name,
                    widget.time,
                  );
                  dose[0].status = "NOT_TAKEN";
                  await DoseRepository().update(dose[0]);
                  setState(() {
                    _isTaken = false;
                  });
                  Navigator.pop(context);
                } else {
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Desmarcar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 6, bottom: 6),
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
          Icon(widget.icon, size: 40, color: const Color(0xFF0147D3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.time.day.toString().padLeft(2, '0')}/${widget.time
                      .month.toString().padLeft(2, '0')}/${widget.time.year
                      .toString().padLeft(4, '0')} - "
                      "${widget.time.hour.toString().padLeft(2, '0')}: ${widget
                      .time.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  widget.dosage,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  _showMyDialog();
                },
                icon: Icon(
                  _isTaken ? Icons.check_circle : Icons.cancel,
                  color: _isTaken ? Colors.green : Colors.red,
                ),
              ),
              Text(_isTaken ? 'Tomado' : 'Não tomado'),
            ],
          ),
        ],
      ),
    );
  }
}
