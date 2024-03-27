import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudBien.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudCategorie.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudEtat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database?> getDatabase() async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  static Future<Database> _initDatabase() async {
    var factory = databaseFactoryFfiWeb;
    var db = await factory.openDatabase('database.db');
    await createSkeleton(db);
    return db;
  }

  static createSkeleton(Database? db) async {
    await EtatDatabaseHelper.initSkeleton(db);
    await CategorieDatabaseHelper.initSkeleton(db);
    await AnnonceLocaleDatabaseHelper.initSkeleton(db);
    await BienDatabaseHelper.initSkeleton(db);
  }
}