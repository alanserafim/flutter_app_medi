import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/repositories/firestore/medicine_doc.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {

  // List<MedicineDoc> medicineList = [];
  // MedicineDocService medicineDocService = MedicineDocService();
  // @override
  // void initState() {
  //   refresh();
  //   super.initState();
  // }
  // refresh() async {
  //   List<MedicineDoc> medicines = await medicineDocService.findAll();
  //   setState(() {
  //     medicineList = medicines;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus medicamentos")),
      body: ListView(
        children: [
          SvgPicture.asset('assets/images/pills.svg', height: 250),
          Container(
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
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "/medication/list");
              },
              child: Text(
                "Medicamentos Cadastrados",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
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
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "/medication/add");
              },
              child: Text(
                "Adicionar Medicamentos",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
