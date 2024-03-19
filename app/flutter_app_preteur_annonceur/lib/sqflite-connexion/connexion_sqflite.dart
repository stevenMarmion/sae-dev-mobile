// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SqfliteConnexion {
  static final SqfliteConnexion _instance = SqfliteConnexion._internal();
  factory SqfliteConnexion() => _instance;

  static Database? _database;

  SqfliteConnexion._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), './../database/preteur-annonceur.db');
    ByteData data = await rootBundle.load("./../database/preteur-annonceur-schema.sql"); // toutes les créations de tables ici
    String schemaSql = utf8.decode(data.buffer.asUint8List());

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(schemaSql);
      },
    );
    return database;
  }


  Future<int> insertData(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('your_table', row);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    Database db = await database;
    return await db.query('your_table');
  }
}

