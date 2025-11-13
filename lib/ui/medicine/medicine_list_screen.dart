import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/firestore/dose_doc.dart';
import '../../data/repositories/firestore/medicine_doc.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  Future<void> _showMyDialog(String medicineName, String medicineId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir medicamento'),
          content: const Text('Confirma a exclusão do medicamento'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await MedicineDocService().delete(medicineId);
                await DoseService().deleteByName(medicineName);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicamentos Cadastrados")),
      body: FutureBuilder(
        future: MedicineDocService().findAll(),
        builder: (context, snapshot) {
          List<MedicineDoc>? items = snapshot.data;
          switch (snapshot.connectionState) {
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
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final MedicineDoc medicine = items[index];
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(medicine.name),
                            IconButton(
                              onPressed: () {
                                _showMyDialog(medicine.name, medicine.id);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
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
        },
      ),
    );
  }
}
