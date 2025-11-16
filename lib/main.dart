import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_medi/storage/storage_screen.dart';
import 'package:flutter_app_medi/ui/initial/base_screen.dart';
import 'package:flutter_app_medi/ui/medicine/medicine_form_screen.dart';
import 'package:flutter_app_medi/ui/medicine/medicine_list_screen.dart';
import 'package:flutter_app_medi/ui/medicine/medicine_screen.dart';
import 'package:flutter_app_medi/ui/schedule/schedule_base_screen.dart';
import 'package:flutter_app_medi/ui/user/user_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ScreenRouter(),
        //'/schedule': (context) => ScheduleBaseScreen(),
        '/medication': (context) => MedicineScreen(),
        '/medication/add': (context) => MedicineFormScreen(),
        '/medication/list': (context) => MedicineListScreen(),
        //'/user': (context) => UserScreen(user: snapshot.data!),
        '/imageScreen' : (context) => StorageScreen(),
      },
    );
  }
}

class ScreenRouter extends StatelessWidget {
  const ScreenRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else {
            if(snapshot.hasData){
              return ScheduleBaseScreen(user: snapshot.data!);
            } else {
              return BaseScreen();
            }
          }
        }
    );
  }
}

