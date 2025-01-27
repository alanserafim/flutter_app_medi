import 'package:flutter/material.dart';
import 'package:flutter_app_medi/data/repositories/user_repository.dart';
import 'package:flutter_svg/svg.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = UserRepository();
  bool _isEditable = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final users = await _repository.findAll(); // Obtém os dados do banco
      if (users.isNotEmpty) {
        final user = users.first; // Supondo que há apenas um usuário
        setState(() {
          nameController.text = user.name;
          emailController.text = user.email;
          dataNascimentoController.text = user.birthDate;
          passwordController.text = user.password;
        });
      }
    } catch (e) {
      // Tratar erro de busca no banco
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados do usuário: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/user.svg',
              height: 250,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE8BB6C),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            enabled: _isEditable,
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
                            enabled: _isEditable,
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
                          // TextFormField(
                          //   controller: dataNascimentoController,
                          //   enabled: _isEditable,
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'a data de nascimento deve ser preenchida';
                          //     }
                          //     return null;
                          //   },
                          //   decoration: InputDecoration(labelText: 'Data de nascimento'),
                          //   style: TextStyle(fontSize: 20),
                          // ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            enabled: _isEditable,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'a senha deve ser preenchida';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'senha'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: ()  async {
                        if (_isEditable) {
                          // Salva os dados após validação
                          if (_formKey.currentState!.validate()) {
                            //await UserRepository().update();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dados alterados com sucesso'),
                              ),
                            );
                            setState(() {
                              _isEditable = false; // Bloqueia os campos novamente
                            });
                          }
                        } else {
                          setState(() {
                            _isEditable = true; // Habilita os campos para edição
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0147D3),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        _isEditable ? 'SALVAR' : 'ALTERAR DADOS',
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
            ),
          ],
        ),
      ),
    );
  }
}
