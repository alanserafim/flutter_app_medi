class MedicamentoDao {

  static const String _nome = 'nome';
  static const String _tipo = 'tipo';
  static const String _frequencia = 'frequencia';
  static const String _horario = 'horario';
  static const String _data_inicio_tratamento = 'data_inicio_tratamento';
  static const String _data_fim_tratamento = 'data_fim_tratamento';

  static const String _tablename = 'medicamentos';
  static const String tableSql =
      'CREATE TABLE $_tablename('
      '$_nome TEXT, '
      '$_tipo TEXT, '
      '$_frequencia TEXT, '
      '$_horario TEXT, '
      '$_data_inicio_tratamento TEXT, '
      '$_data_fim_tratamento TEXT, ';

  save() async {}
  update() async {}
  findAll() async {}
  find() async {}
  delete() async {}

}