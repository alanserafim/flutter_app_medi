import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/sqflite/user_repository.dart';
import 'package:flutter_app_medi/domain/models/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //Variaveis do formulário
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future handleSignUp(User user) async {
    var userExits = await UserRepository().find(user.email);
    if (userExits.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ja existe na base de dados')),
      );
    } else {
      await UserRepository().save(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('cadastro efetuado com sucesso')),
      );
      Navigator.pushNamed(context, '/schedule');
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
          color: Color(0xFFE8BB6C),
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
                  icon: Icon(Icons.arrow_back, color: Colors.black, size: 32),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: Text(
                    'CADASTRE-SE',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira um nome válido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira um email válido';
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
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira uma senha válida';
                      }
                      if (value.length < 8) {
                        return 'A senha deve ter pelo menos 8 caracteres.';
                      }
                      if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                        return 'A senha deve conter pelo menos uma letra maiúscula.';
                      }
                      if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                        return 'A senha deve conter pelo menos um número.';
                      }
                      if (!RegExp(r'^(?=.*[!@#\$&*~])').hasMatch(value)) {
                        return 'A senha deve conter pelo menos um caractere especial (!@#\$&*~).';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'senha'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  User user = User(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    birthDate: "00/00/0000",
                  );
                  await handleSignUp(user);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0147D3),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'CADASTRAR',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
