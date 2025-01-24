import '../../domain/models/medicine.dart';

class MedicineRepository {

  static const String _nome = 'nome';
  static const String _apelido= 'apelido';
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
      '$_frequencia_semanal TEXT, '
      '$_frequencia_diaria TEXT, '
      '$_dose_intervalo TEXT, '
      '$_horario_primeira_dose TEXT, '
      '$_duracao_tratamento TEXT, ';

  save(Medicine medicine) async {}
  update(Medicine medicine) async {}
  findAll() async {}
  find(String medicineName) async {}
  delete(String medicineName) async {}

  // Métodos de apoio
  List<Medicine> toList(List<Map<String, dynamic>> mapaDeMedicamentos) {
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
        firstDoseTime: linha[_horario_primeira_dose],
        treatmentDuration: linha[_duracao_tratamento],

      );
      medicines.add(medicine);
    }
    return medicines;
  }
  Map<String, dynamic> toMap(Medicine medicine) {
    final Map<String, dynamic> mapaDeMedicamentos = Map();
    mapaDeMedicamentos[_nome] = medicine.name;
    mapaDeMedicamentos[_apelido] = medicine.alias;
    mapaDeMedicamentos[_tipo] = medicine.type;
    mapaDeMedicamentos[_dosagem] =  medicine.dosage;
    mapaDeMedicamentos[_frequencia_semanal] = medicine.weeklyFrequency;
    mapaDeMedicamentos[_frequencia_diaria] = medicine.dailyFrequency;
    mapaDeMedicamentos[_dose_intervalo] = medicine.doseInterval;
    mapaDeMedicamentos[_horario_primeira_dose] = medicine.firstDoseTime;
    mapaDeMedicamentos[_duracao_tratamento] = medicine.treatmentDuration;
    return mapaDeMedicamentos;
  }
}