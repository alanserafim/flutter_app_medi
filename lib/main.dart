import 'package:flutter/material.dart';
import 'package:flutter_app_medi/ui/initial/base_screen.dart';
import 'package:flutter_app_medi/ui/medicine/medicine_form_screen.dart';
import 'package:flutter_app_medi/ui/medicine/medicine_list_screen.dart';
import 'package:flutter_app_medi/ui/medicine/medicine_screen.dart';
import 'package:flutter_app_medi/ui/schedule/schedule_base_screen.dart';
import 'package:flutter_app_medi/ui/user/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BaseScreen(),
        '/schedule': (context) => ScheduleBaseScreen(),
        '/medication': (context) => MedicineScreen(),
        '/medication/add': (context) => MedicineFormScreen(),
        '/medication/list': (context) => MedicineListScreen(),
        '/user': (context) => UserScreen(),
      },
    );
  }
}
