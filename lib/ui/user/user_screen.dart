import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SvgPicture.asset(
              'assets/images/user.svg',
              height: 250,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE8BB6C),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              //return 'O nome deve ser preenchido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'nome'),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'o email deve ser preenchido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'e-mail'),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: dataNascimentoController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'a data de nascimento deve ser preenchida';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Data de nascimento'),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'a senha deve ser preenchida';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'dosagem'),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // some signup logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('dados alterados com sucesso'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0147D3),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'ALTERAR DADOS',
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
          ],
        ),
      ),
    );
  }
}
