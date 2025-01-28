import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/user_repository.dart';

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

  Future handeSignin(email, password) async {
    List user = await UserRepository().find(email);
    if (user.isNotEmpty) {
      if(user[0].password == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login efetuado com sucesso'),
          ),
        );
        Navigator.pushNamed(context, '/schedule');
      }  else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário ou senha incorreta'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha incorreta'),
        ),
      );
    }

  }

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
            SizedBox(height: 16),
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
                      final emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
                      if (!emailRegex.hasMatch(value)) {
                          return 'Por favor, insira um email válido.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'e-mail'),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await handeSignin(emailController.text, passwordController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE8BB6C),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
          ],
        ),
      ),
    );
  }
}
