import 'package:sqflite/sqflite.dart';

import '../../../domain/models/medi_user.dart';
import '../../config/databaseHelper.dart';

class UserRepository {
  static const String _nome = 'nome';
  static const String _email = 'email';


  static const String _tablename = 'usuarios';
  static const String tableSql =
      'CREATE TABLE $_tablename('
      '$_nome TEXT, '
      '$_email TEXT, ';

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  findAll() async {
    print("Acessando o findAll - userRepository");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
    );
    return toList(result);
  }

  Future<List<MediUser>> find(String email) async {
    print("Acessando o find - UserRepository");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_email = ?',
      whereArgs: [email],
    );
    return toList(result);
  }

  save(MediUser mediUser) async {
    print("Iniciando o save - userRepository");
    final Database bancoDeDados = await _dbHelper.database;
    Map<String, dynamic> mediUserMap = toMap(mediUser);

    var mediUserExists = await find(mediUser.name);
    if (mediUserExists.isEmpty) {
      print("usuário não existente");
      return await bancoDeDados.insert(_tablename, mediUserMap);
    } else {
      print("Usuário já existente na base de dados");
      return null;
    }
  }

  update(MediUser mediUser) async {
    print("Iniciando o update - UserRepository");
    final Database bancoDeDados = await _dbHelper.database;
    Map<String, dynamic> mediUserMap = toMap(mediUser);

    var mediUserExists = await find(mediUser.name);
    if (mediUserExists.isEmpty) {
      print("usuário não existente");
    } else {
      return bancoDeDados.update(
        _tablename,
        mediUserMap,
        where: '$_nome = ?',
        whereArgs: [mediUser.name],
      );
    }
  }

  delete(String mediUserName) async {
    print("Deletando usuário - userRepository");
    final Database bancoDeDados = await _dbHelper.database;
    return bancoDeDados.delete(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [mediUserName],
    );
  }

  // Métodos de apoio
  List<MediUser> toList(List<Map<String, dynamic>> mapaDeUsuarios) {
    print("Metodo toList - UserRepository");
    final List<MediUser> mediUsers = [];
    for (Map<String, dynamic> linha in mapaDeUsuarios) {
      final MediUser mediUser = MediUser(
        name: linha[_nome],
        email: linha[_email],
        photoUrl: null
      );
      mediUsers.add(mediUser);
    }
    return mediUsers;
  }

  Map<String, dynamic> toMap(MediUser mediUser) {
    print("Metodo toMap - UserRepository");
    final Map<String, dynamic> mapaDeUsuarios = Map();
    mapaDeUsuarios[_nome] = mediUser.name;
    mapaDeUsuarios[_email] = mediUser.email;
    return mapaDeUsuarios;
  }
}
