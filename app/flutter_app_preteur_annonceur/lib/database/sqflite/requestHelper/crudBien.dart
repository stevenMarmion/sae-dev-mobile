import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class BienDatabaseHelper {
  
  static Future<void> initSkeleton(Database? db) async {
    await db?.execute('''
      CREATE TABLE IF NOT EXISTS Bien (
        ID_Bien INTEGER PRIMARY KEY,
        Nom TEXT,
        ID_Categorie INTEGER,
        FOREIGN KEY (ID_Categorie) REFERENCES CATEGORIE(ID_Categorie)
      )
    ''');
  }

  static Future<void> insertBien(String nom, int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.insert('Bien', {
      'Nom': nom,
      'ID_Categorie': idCategorie,
    });
  }

  static Future<List<Map<String, dynamic>>?> getBiens() async {
    Database? db = await DatabaseHelper.getDatabase();
    return await db?.query('Bien');
  }

  static Future<Map<String, dynamic>?> getBienById(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('Bien', where: 'ID_Bien = ?', whereArgs: [id]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateBien(int id, String nom, int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.update('Bien', {
      'Nom': nom,
      'ID_Categorie': idCategorie,
    }, where: 'ID_Bien = ?', whereArgs: [id]);
  }

  static Future<void> deleteBien(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.delete('Bien', where: 'ID_Bien = ?', whereArgs: [id]);
  }
}
