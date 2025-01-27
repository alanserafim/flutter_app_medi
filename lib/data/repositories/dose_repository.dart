import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/dose.dart';
import '../config/databaseHelper.dart';

class DoseRepository {

  static const String _tablename = 'doses';

  static const String _nome = 'nome';
  static const String _apelido= 'apelido';
  static const String _dataHora = 'data_hora';
  static const String _dosagem = 'dosagem';
  static const String _icone = 'icone';
  static const String _status = 'status';


  static const String tableSql =
      'CREATE TABLE $_tablename('
      '$_nome TEXT, '
      '$_apelido TEXT, '
      '$_dataHora TEXT, '
      '$_dosagem TEXT, '
      '$_icone TEXT, '
      '$_status TEXT)';

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Dose>>findAll() async {
    print("Acessando o findAll - DoseRepository");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(_tablename);
    return toList(result);
  }
  Future<List<Dose>> find(String doseName) async {
    print("Acessando find - DoseRepository ");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [doseName],
    );
    return toList(result);
  }
  save(Dose dose) async {
    print("Iniciando o save - DoseRepository");
    final Database bancoDeDados = await _dbHelper.database;
    Map<String, dynamic> doseMap = toMap(dose);
    return await bancoDeDados.insert(_tablename, doseMap);
  }
  delete(String doseName) async {
    print("Deletando doses - DoseRepository");
    final Database bancoDeDados = await _dbHelper.database;
    return bancoDeDados.delete(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [doseName],
    );
  }

  // Métodos de apoio
  List<Dose> toList(List<Map<String, dynamic>> mapaDeDoses) {
    print("metodo toList - DoseRepository");
    final List<Dose> doses = [];
    for (Map<String, dynamic> linha in mapaDeDoses) {
      final Dose dose = Dose(
        name: linha[_nome],
        dayTime: DateTime.parse(linha[_dataHora]),
        dosage: linha[_dosagem],
        alias: linha[_apelido],
        icon: Icons.vaccines, //corrigir icones
        status: linha[_status],
      );
      doses.add(dose);
    }
    return doses;
  }
  Map<String, dynamic> toMap(Dose dose) {
    print("metodo toMap - DoseRepository");
    final Map<String, dynamic> mapaDeDoses = Map();
    mapaDeDoses[_nome] = dose.name;
    mapaDeDoses[_dataHora] = dose.dayTime.toIso8601String();
    mapaDeDoses[_dosagem] = dose.dosage;
    mapaDeDoses[_apelido] =  dose.alias;
    mapaDeDoses[_icone] = dose.icon.toString();
    mapaDeDoses[_status] = dose.status;
    return mapaDeDoses;
  }




}