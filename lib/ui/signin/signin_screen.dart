import 'package:flutter/material.dart';
import 'package:flutter_app_medi/authentication/services/auth_service.dart';
import 'package:flutter_app_medi/data/repositories/sqflite/user_repository.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height / 1.91,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF0147D3),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 32),
                ),
                Container(
                  margin: EdgeInsets.only(left: 80),
                  child: Text(
                    'ENTRAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O campo e-mail dever ser preenchido';
                      }
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Por favor, insira um email válido.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'e-mail'),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O campo senha deve ser preenchido';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(labelText: 'senha'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await handeSignin(
                      emailController.text,
                      passwordController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE8BB6C),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                ),
                child: Text(
                  'ACESSAR',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                handleForgotPassword();
              },
              child: Text(
                'Esqueceu a senha?',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future handeSignin(email, password) async {
    String? erro = await authService.userSignIn(
      email: email,
      password: password,
    );
    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login efetuado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamed(context, '/schedule');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  handleForgotPassword() async {
    String email = emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController redefinicaoController = TextEditingController(
          text: email,
        );
        return AlertDialog(
          title: Text('Esqueceu a senha?'),
          content: TextFormField(
            controller: redefinicaoController,
            decoration: InputDecoration(label: Text('Confirme seu e-mail')),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          actions: [
            TextButton(onPressed: () async {
              String? erro = await authService.redefinePassword(email: redefinicaoController.text);
              if (erro == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('e-mail de redefinição enviado!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(erro), backgroundColor: Colors.red),
                );
              }
              Navigator.pop(context);
            }, child: (Text("Redefinir senha"))),
          ],
        );
      },
    );

  }
}
