import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_medi/authentication/services/auth_service.dart';
import 'package:flutter_svg/svg.dart';

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditable = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

_loadUserData() {
    setState(() {
      emailController.text = widget.user.email!;
      nameController.text = widget.user.displayName!;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child:
                  //SvgPicture.asset('assets/images/user.svg', height: 380),
                  CircleAvatar(
                      backgroundImage:
                      (widget.user.photoURL != null)
                          ? NetworkImage(widget.user.photoURL!)
                          : null,
                      maxRadius: 148
                  ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Mudar foto de perfil"),
              onTap: (){
                Navigator.pushNamed(context, '/imageScreen');
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Color(0xFFE8BB6C)),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            enabled: _isEditable,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'O nome deve ser preenchido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'nome'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: emailController,
                            enabled: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'o email deve ser preenchido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'e-mail'),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (_isEditable) {
                          if (_formKey.currentState!.validate()) {
                            String? erro = await AuthService().updateName(nameController.text);
                            if(erro == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Dados alterados com sucesso'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() {
                                _isEditable = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Erro ao alterar dados"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                _isEditable = false;
                              });
                            }
                          }
                        } else {
                          setState(() {
                            _isEditable = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0147D3),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
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
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        showPasswordConfirmationDialog(context: context, email: "email");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        'REMOVER CONTA',
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

showPasswordConfirmationDialog({
  required BuildContext context,
  required String email
}){
  showDialog(
    context: context,
    builder: (context){
      TextEditingController passwordController = TextEditingController();
      return AlertDialog(
        title: Text("Deseja remover a conta com o email $email? "),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              Text("Para confirmar a remoção da conta digite sua senha: "),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'senha'),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              if(passwordController.text.isEmpty){
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A senha deve ser preenchida'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              AuthService().removeAccount(password: passwordController.text)
                  .then((String? erro){
                    if(erro == null){
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao remover a conta'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
              });
            },
            child: Text("EXCLUIR CONTA"),
          ),
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("CANCELAR"),
          ),
        ],
      );
    }
  );
}
