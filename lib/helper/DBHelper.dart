import 'package:app_divide_lista/model/pessoa.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_divide_lista/model/item.dart';

class DBHelper {
  static final String tabelaItens = "Itens";
  static final String tabelaPessoas = "Pessoas";
  static final String tabelaPessoasItens = "PessoasItens";

  // padrão singleton
  static final DBHelper _dbHelper = DBHelper._internal();

  Database _db;

  factory DBHelper() {
    return _dbHelper;
  }

  DBHelper._internal();

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $tabelaItens ("
        " id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, quantidade VARCHAR)";
    String sqlPessoas = "CREATE TABLE $tabelaPessoas ("
        " id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, itens VARCHAR)";
    String sqlPessoasItens = "CREATE TABLE $tabelaPessoasItens ("
        " id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, itens VARCHAR)";

    await db.execute(sql);
    await db.execute(sqlPessoas);
    await db.execute(sqlPessoasItens);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_divide_lista.db");

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);

    print("banco: " + caminhoBancoDados);
    return db;
  }

  Future<int> salvarItem(Item item) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(tabelaItens, item.toMap());

    return resultado;
  }

  recuperarItens() async {
    var bancoDados = await db;

    String sql = "SELECT * FROM $tabelaItens ORDER BY nome ASC";
    List itens = await bancoDados.rawQuery(sql);

    return itens;
  }

  Future<int> removerItens(int id) async {
    var bancoDados = await db;

    return await bancoDados
        .delete(tabelaItens, where: "id = ?", whereArgs: [id]);
  }

  Future<int> atualizarItens(Item item) async {
    var bancoDados = await db;
    return await bancoDados.update(tabelaItens, item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
  }

  Future<int> salvarPessoa(Pessoa pessoa) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(tabelaPessoas, pessoa.toMap());

    return resultado;
  }

  recuperarPessoas() async {
    var bancoDados = await db;

    String sql = "SELECT * FROM $tabelaPessoas ORDER BY nome ASC";
    List pessoas = await bancoDados.rawQuery(sql);

    return pessoas;
  }

  Future<int> removerPessoas(int id) async {
    var bancoDados = await db;

    return await bancoDados
        .delete(tabelaPessoas, where: "id = ?", whereArgs: [id]);
  }

  Future<int> atualizarPessoas(Pessoa pessoa) async {
    var bancoDados = await db;

    return await bancoDados.update(tabelaPessoas, pessoa.toMap(),
        where: "id = ?", whererArgs: [pessoa.id]);
  }

  Future<int> removerPessoaItens() async {
    var bancoDados = await db;
    return await bancoDados.delete(tabelaPessoasItens);
  }
}
