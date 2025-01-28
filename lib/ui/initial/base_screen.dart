import 'package:flutter/material.dart';
import 'package:flutter_app_medi/ui/initial/initial_screen.dart';
import 'package:flutter_app_medi/ui/signin/signin_screen.dart';
import 'package:flutter_app_medi/ui/signup/signup_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String currentScreen = 'initial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/medical_prescription.png'),
                ),
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: _buildScreen(currentScreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(String screen) {
    switch (screen) {
      case 'signin':
        return SigninScreen(
          onBack: () => setState(() => currentScreen = 'initial'),
        );
      case 'signup':
        return SignupScreen(
          onBack: () => setState(() => currentScreen = 'initial'),
        );
      default:
        return InitialScreen(
          onLogin: () => setState(() => currentScreen = 'signin'),
          onSignup: () => setState(() => currentScreen = 'signup'),
        );
    }
  }
}
