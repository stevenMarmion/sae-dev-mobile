import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class AnnonceLocaleDatabaseHelper {
  
  static Future<void> initSkeleton(Database? db) async {
    await db?.execute('''
      CREATE TABLE IF NOT EXISTS AnnonceLocale (
        ID_Annonce INTEGER PRIMARY KEY,
        Titre TEXT,
        Description TEXT,
        ID_Categorie INTEGER,
        ID_Etat INTEGER,
        Date_Creation DATE,
        Date_Cloture DATE,
        FOREIGN KEY (ID_Categorie) REFERENCES CATEGORIE(ID_Categorie),
        FOREIGN KEY (ID_Etat) REFERENCES ETAT(ID_Etat)
      )
    ''');
  }

  static Future<void> insertAnnonce(String titre, String description, int idCategorie, int idEtat, String dateCreation, String dateCloture) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.insert('AnnonceLocale', {
      'Titre': titre,
      'Description': description,
      'ID_Categorie': idCategorie,
      'ID_Etat': idEtat,
      'Date_Creation': dateCreation,
      'Date_Cloture': dateCloture,
    });
  }

  static Future<List<Map<String, dynamic>>?> getAnnonces() async {
    Database? db = await DatabaseHelper.getDatabase();
    return await db?.query('AnnonceLocale');
  }

  static Future<Map<String, dynamic>?> getAnnonceById(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('AnnonceLocale', where: 'ID_Annonce = ?', whereArgs: [id]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateAnnonce(int id, String titre, String description, int idCategorie, int idEtat, String dateCreation, String dateCloture) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.update('AnnonceLocale', {
      'Titre': titre,
      'Description': description,
      'ID_Categorie': idCategorie,
      'ID_Etat': idEtat,
      'Date_Creation': dateCreation,
      'Date_Cloture': dateCloture,
    }, where: 'ID_Annonce = ?', whereArgs: [id]);
  }

  static Future<void> deleteAnnonce(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.delete('AnnonceLocale', where: 'ID_Annonce = ?', whereArgs: [id]);
  }
}
