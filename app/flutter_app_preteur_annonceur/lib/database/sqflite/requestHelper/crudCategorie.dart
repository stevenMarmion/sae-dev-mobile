import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class CategorieDatabaseHelper {

  static Future<void> initSkeleton(Database? db) async {
    await db?.execute('''
      CREATE TABLE IF NOT EXISTS CATEGORIE (
        ID_Categorie INTEGER PRIMARY KEY,
        Nom_Categorie TEXT,
        Description_Categorie TEXT
      )
    ''');

    await db?.execute('''
      INSERT OR IGNORE INTO CATEGORIE (ID_Categorie, Nom_Categorie, Description_Categorie) VALUES
        (1, 'Électronique', 'Téléphones, ordinateurs, appareils photo, etc.'),
        (2, 'Électroménager', 'Réfrigérateurs, lave-linge, lave-vaisselle, etc.'),
        (3, 'Outils et bricolage', 'Perceuses, scies, tournevis, etc.'),
        (4, 'Sports et loisirs', 'Vélos, raquettes, matériel de camping, etc.'),
        (5, 'Mode et accessoires', 'Vêtements, chaussures, sacs à main, etc.'),
        (6, 'Maison et décoration', 'Meubles, luminaires, décoration, etc.'),
        (7, 'Instruments de musique', 'Guitares, pianos, batterie, etc.'),
        (8, 'Livres et divertissement', 'Romans, bandes dessinées, DVD, etc.'),
        (9, 'Bébé et enfant', 'Poussettes, jouets, vêtements pour bébés, etc.'),
        (10, 'Santé et bien-être', 'Équipement de fitness, produits de beauté, etc.');
    ''');
  }

  static Future<void> insertCategorie(String nomCategorie, String descriptionCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.insert('CATEGORIE', {
      'Nom_Categorie': nomCategorie,
      'Description_Categorie': descriptionCategorie,
    });
  }

  static Future<List<Map<String, dynamic>>?> getCategories() async {
    Database? db = await DatabaseHelper.getDatabase();
    return await db?.query('CATEGORIE');
  }

  static Future<Map<String, dynamic>?> getCategorieById(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('CATEGORIE', where: 'ID_Categorie = ?', whereArgs: [id]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<Map<String, dynamic>?> getCategorieByName(String name) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('CATEGORIE', where: 'Nom_Categorie = ?', whereArgs: [name]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateCategorie(int id, String nomCategorie, String descriptionCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.update('CATEGORIE', {
      'Nom_Categorie': nomCategorie,
      'Description_Categorie': descriptionCategorie,
    }, where: 'ID_Categorie = ?', whereArgs: [id]);
  }

  static Future<void> deleteCategorie(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.delete('CATEGORIE', where: 'ID_Categorie = ?', whereArgs: [id]);
  }
}
