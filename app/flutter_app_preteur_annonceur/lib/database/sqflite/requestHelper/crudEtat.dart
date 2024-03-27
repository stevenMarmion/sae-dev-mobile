import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class EtatDatabaseHelper {

  static Future<void> initSkeleton(Database? db) async {
    await db?.execute('''
      CREATE TABLE IF NOT EXISTS ETAT (
        ID_Etat INTEGER PRIMARY KEY,
        Nom_Etat TEXT,
        Description_Etat TEXT
      )
    ''');

    await db?.execute('''
      INSERT OR IGNORE INTO ETAT (ID_Etat, Nom_Etat, Description_Etat) VALUES
        (1, 'Ouverte', 'Annonce ouverte'),
        (2, 'Pourvue', 'Annonce pourvue'),
        (3, 'Clôturée', 'Annonce clôturée')
    ''');
  }

  static Future<void> insertEtat(String nomEtat, String descriptionEtat) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.insert('ETAT', {
      'Nom_Etat': nomEtat,
      'Description_Etat': descriptionEtat,
    });
  }

  static Future<List<Map<String, dynamic>>?> getEtats() async {
    Database? db = await DatabaseHelper.getDatabase();
    return await db?.query('ETAT');
  }

  static Future<Map<String, dynamic>?> getEtatById(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('ETAT', where: 'ID_Etat = ?', whereArgs: [id]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<Map<String, dynamic>?> getEtatByName(String name) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('ETAT', where: 'Nom_Etat = ?', whereArgs: [name]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateEtat(int id, String nomEtat, String descriptionEtat) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.update('ETAT', {
      'Nom_Etat': nomEtat,
      'Description_Etat': descriptionEtat,
    }, where: 'ID_Etat = ?', whereArgs: [id]);
  }

  static Future<void> deleteEtat(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.delete('ETAT', where: 'ID_Etat = ?', whereArgs: [id]);
  }
}
