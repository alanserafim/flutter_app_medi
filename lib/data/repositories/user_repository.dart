import 'package:sqflite/sqflite.dart';

import '../../domain/models/user.dart';
import '../config/databaseHelper.dart';

class UserRepository {
  static const String _nome = 'nome';
  static const String _email = 'email';
  static const String _dataNascimento = 'data_nascimento';
  static const String _senha = 'senha';

  static const String _tablename = 'usuarios';
  static const String tableSql =
      'CREATE TABLE $_tablename('
      '$_nome TEXT, '
      '$_email TEXT, '
      '$_dataNascimento TEXT, '
      '$_senha TEXT)';

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  findAll() async {
    print("Acessando o findAll - userRepository");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(_tablename);
    return toList(result);
  }
  Future<List<User>> find(String email) async {
    print("Acessando o find - UserRepository");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_email = ?',
      whereArgs: [email],
    );
    return toList(result);
  }

  save(User user) async {
    print("Iniciando o save - userRepository");
    final Database bancoDeDados = await _dbHelper.database;
    Map<String, dynamic> userMap = toMap(user);

    var userExists = await find(user.name);
    if (userExists.isEmpty) {
      print("usuário não existente");
      return await bancoDeDados.insert(_tablename, userMap);
    } else {
      print("Usuário já existente na base de dados");
      return null;
    }
  }
  update(User user) async {
    print("Iniciando o update - UserRepository");
    final Database bancoDeDados = await _dbHelper.database;
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
  delete(String userName) async {
    print("Deletando usuário - userRepository");
    final Database bancoDeDados = await _dbHelper.database;
    return bancoDeDados.delete(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [userName],
    );
  }

  // Métodos de apoio
  List<User> toList(List<Map<String, dynamic>> mapaDeUsuarios) {
    print("Metodo toList - UserRepository");
    final List<User> users = [];
    for (Map<String, dynamic> linha in mapaDeUsuarios) {
      final User user = User(
        name: linha[_nome],
        email: linha[_email],
        birthDate: linha[_dataNascimento],
        password: linha[_senha],
      );
      users.add(user);
    }
    return users;
  }
  Map<String, dynamic> toMap(User user) {
    print("Metodo toMap - UserRepository");
    final Map<String, dynamic> mapaDeUsuarios = Map();
    mapaDeUsuarios[_nome] = user.name;
    mapaDeUsuarios[_email] = user.email;
    mapaDeUsuarios[_dataNascimento] = user.birthDate;
    mapaDeUsuarios[_senha] = user.password;
    return mapaDeUsuarios;
  }
}
