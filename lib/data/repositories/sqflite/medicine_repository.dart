import 'package:sqflite/sqflite.dart';

import '../../../domain/models/medicine.dart';
import '../../config/databaseHelper.dart';

class MedicineRepository {
  static const String _nome = 'nome';
  static const String _apelido = 'apelido';
  static const String _tipo = 'tipo';
  static const String _dosagem = 'dosagem';
  static const String _frequencia_semanal = 'frequencia_semanal';
  static const String _frequencia_diaria = 'frequencia_diaria';
  static const String _dose_intervalo = 'dose_intervalo';
  static const String _horario_primeira_dose = 'horario_primeira_dose';
  static const String _duracao_tratamento = 'duracao_tratamento';

  static const String _tablename = 'medicamentos';

  static const String tableSql =
      'CREATE TABLE $_tablename('
      '$_nome TEXT, '
      '$_apelido TEXT, '
      '$_tipo TEXT, '
      '$_dosagem TEXT, '
      '$_frequencia_semanal INTEGER, '
      '$_frequencia_diaria INTEGER, '
      '$_dose_intervalo INTEGER, '
      '$_duracao_tratamento INTEGER, '
      '$_horario_primeira_dose TEXT)';

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Medicine>> findAll() async {
    print("Acessando o findAll - MedicineRepository");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
    );
    return toList(result);
  }

  Future<List<Medicine>> find(String medicineName) async {
    print("Acessando find - MedicineRepository ");
    final Database bancoDeDados = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [medicineName],
    );
    return toList(result);
  }

  save(Medicine medicine) async {
    print("Iniciando o save");
    final Database bancoDeDados = await _dbHelper.database;
    Map<String, dynamic> medicineMap = toMap(medicine);

    var medicineExists = await find(medicine.name);
    if (medicineExists.isEmpty) {
      print("Medicamento não existente");
      return await bancoDeDados.insert(_tablename, medicineMap);
    } else {
      print("Medicamento existente na base de dados");
    }
  }

  update(Medicine medicine) async {
    print("Iniciando o update");
    final Database bancoDeDados = await _dbHelper.database;
    Map<String, dynamic> medicineMap = toMap(medicine);

    var medicineExists = await find(medicine.name);
    if (medicineExists.isEmpty) {
      print("medicamento não existente");
    } else {
      return bancoDeDados.update(
        _tablename,
        medicineMap,
        where: '$_nome = ?',
        whereArgs: [medicine.name],
      );
    }
  }

  delete(String medicineName) async {
    print("Deletando medicamento");
    final Database bancoDeDados = await _dbHelper.database;
    return bancoDeDados.delete(
      _tablename,
      where: '$_nome = ?',
      whereArgs: [medicineName],
    );
  }

  // Métodos de apoio
  List<Medicine> toList(List<Map<String, dynamic>> mapaDeMedicamentos) {
    print("Método toList - MedicineRepository");
    final List<Medicine> medicines = [];
    for (Map<String, dynamic> linha in mapaDeMedicamentos) {
      final Medicine medicine = Medicine(
        name: linha[_nome],
        alias: linha[_apelido],
        type: linha[_tipo],
        dosage: linha[_dosagem],
        weeklyFrequency: linha[_frequencia_semanal],
        dailyFrequency: linha[_frequencia_diaria],
        doseInterval: linha[_dose_intervalo],
        firstDoseTime: DateTime.parse(linha[_horario_primeira_dose]),
        treatmentDuration: linha[_duracao_tratamento],
      );
      medicines.add(medicine);
    }
    return medicines;
  }

  Map<String, dynamic> toMap(Medicine medicine) {
    print("Convertendo medicamento em map - MedicineRepository");
    final Map<String, dynamic> mapaDeMedicamentos = Map();
    mapaDeMedicamentos[_nome] = medicine.name;
    mapaDeMedicamentos[_apelido] = medicine.alias;
    mapaDeMedicamentos[_tipo] = medicine.type;
    mapaDeMedicamentos[_dosagem] = medicine.dosage;
    mapaDeMedicamentos[_frequencia_semanal] = medicine.weeklyFrequency;
    mapaDeMedicamentos[_frequencia_diaria] = medicine.dailyFrequency;
    mapaDeMedicamentos[_dose_intervalo] = medicine.doseInterval;
    mapaDeMedicamentos[_horario_primeira_dose] =
        medicine.firstDoseTime.toIso8601String();
    mapaDeMedicamentos[_duracao_tratamento] = medicine.treatmentDuration;
    print('Mapa de medicamentos: $mapaDeMedicamentos');
    return mapaDeMedicamentos;
  }
}
