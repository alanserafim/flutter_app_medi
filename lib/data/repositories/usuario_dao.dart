class UsuarioDao {

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

  save() async {}
  update() async {}
  findAll() async {}
  find() async {}
  delete() async {}

}