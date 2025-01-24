import 'package:sqflite/sqflite.dart';

import '../../domain/models/user.dart';
import '../config/database.dart';

class UserRepository {
  static const String _nome = 'nome';
  static const String _cpf = 'cpf';
  static const String _dataNascimento = 'data_nascimento';
  static const String _senha = 'senha';

  static const String _tablename = 'usuarios';
  static const String tableSql =
      'CREATE TABLE $_tablename('
      '$_nome TEXT, '
      '$_cpf TEXT, '
      '$_dataNascimento TEXT, '
      '$_senha TEXT';

  save(User user) async {
    print("Iniciando o save");
    final Database bancoDeDados = await getDatabase();
    Map<String, dynamic> userMap = toMap(user);

    var userExists = await find(user.name);
    if (userExists.isEmpty) {
      print("usuário não existente");
      return await bancoDeDados.insert(_tablename, userMap);
    } else {
      print("Usuário já existente na base de dados");
    }
  }

  update(User user) async {
    print("Iniciando o update");
    final Database bancoDeDados = await getDatabase();
    Map<String, dynamic> userMap = toMap(user);

    var userExists = await find(user.name);
    if (userExists.isEmpty) {
      print("usuário não existente");
    } else {
      return bancoDeDados.update(
        _tablename,
        userMap,
        where: '$_nome = ?',
        whereArgs: [user.name],
      );
    }
  }

  findAll() async {
    print("Acessando o findAll");
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDeDados.query(_tablename);
    print("Procurando dados no banco de dados ... encontrado: $result");
    return toList(result);
  }

  Future<List<User>> find(String name) async {
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [name],
    );
    print("Usuário encontrado: ${toList(result)}");
    return toList(result);
  }

  delete(String userName) async {
    print("Deletando usuário");
    final Database bancoDeDados = await getDatabase();
    return bancoDeDados.delete(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [userName],
    );
  }

  // Métodos de apoio
  List<User> toList(List<Map<String, dynamic>> mapaDeUsuarios) {
    final List<User> users = [];
    for (Map<String, dynamic> linha in mapaDeUsuarios) {
      final User user = User(
        name: linha[_nome],
        cpf: linha[_cpf],
        birthDate: linha[_dataNascimento],
        password: linha[_senha],
      );
      users.add(user);
    }
    return users;
  }

  Map<String, dynamic> toMap(User user) {
    final Map<String, dynamic> mapaDeUsuarios = Map();
    mapaDeUsuarios[_nome] = user.name;
    mapaDeUsuarios[_cpf] = user.cpf;
    mapaDeUsuarios[_dataNascimento] = user.birthDate;
    mapaDeUsuarios[_senha] = user.password;
    return mapaDeUsuarios;
  }
}
