import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/documento.dart';

class DbHelper {
  String tblDocumento = "documento";
  String colId = "id";
  String colNumero = "numero";
  String colTitulo = "titulo";
  String colDescricao = "descricao";
  String colPrioridade = "prioridade";
  String colData = "data";

  DbHelper._internal();
  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database? _db;

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "/documentos_ged.db";
    var dbDoc = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbDoc;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblDocumento ($colId INTEGER PRIMARY KEY, $colNumero TEXT, " +
            "$colTitulo TEXT, $colDescricao TEXT, $colPrioridade INTEGER, $colData TEXT)");
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db!;
  }

  Future<int> insertDocumento(Documento doc) async {
    Database db = await this.db;
    var result = await db.insert(tblDocumento, doc.toMap());
    return result;
  }

  Future<List> getDocumentos() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblDocumento order by $colPrioridade ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count(*) from $tblDocumento")
    );
    return result!;
  }

  Future<int> updateDocumento(Documento doc) async {
    var db = await this.db;
    var result = await db.update(tblDocumento, doc.toMap(),
        where: "$colId = ?", whereArgs: [doc.id]);
    return result;
  }

  Future<int> deleteDocumento(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblDocumento WHERE $colId = $id');
    return result;
  }
}