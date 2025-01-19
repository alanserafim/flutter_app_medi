import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitialScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignup;

  const InitialScreen({
    super.key,
    required this.onLogin,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Medi',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
          Text(
            'tome seus remédios na hora certa!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          SizedBox(
            width: 250,
            height: 70,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0147D3),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'ENTRAR',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 250,
            height: 70,
            child: ElevatedButton(
              onPressed: onSignup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE8BB6C),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'CADASTRE-SE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'ou cadastre-se usando suas redes',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/logo-facebook.svg',
                      height: 50,
                    ), // Replace with actual path
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                  Text("facebook"),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/logo-google.svg',
                      height: 50,
                    ),
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                  Text("gmail"),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/logo-linkedin.svg',
                      height: 50,
                    ),
                    onPressed: () {
                      // Handle LinkedIn login
                    },
                  ),
                  Text("linkedin"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
