import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class BienDatabaseHelper {
  
  static Future<void> initSkeleton(Database? db) async {
    await db?.execute('''
      CREATE TABLE IF NOT EXISTS Bien (
        ID_Bien INTEGER PRIMARY KEY,
        Nom TEXT,
        description TEXT,
        ID_Categorie INTEGER,
        FOREIGN KEY (ID_Categorie) REFERENCES CATEGORIE(ID_Categorie)
      )
    ''');
    await BienDatabaseHelper.insertBien('iPhone 13 Pro', 'Smartphone haut de gamme avec caméra professionnelle', 1);
    await BienDatabaseHelper.insertBien('Réfrigérateur Samsung', 'Réfrigérateur avec technologie avancée de conservation des aliments', 2);
    await BienDatabaseHelper.insertBien('Perceuse Bosch', 'Perceuse électrique sans fil avec batterie rechargeable', 3);
    await BienDatabaseHelper.insertBien('Vélo de montagne', 'Vélo tout terrain pour les amateurs de sports extrêmes', 4);
    await BienDatabaseHelper.insertBien('Chemise Ralph Lauren', 'Chemise élégante et confortable pour hommes', 5);
    await BienDatabaseHelper.insertBien('Canapé d\'angle en cuir', 'Canapé spacieux et confortable pour le salon', 6);
    await BienDatabaseHelper.insertBien('Guitare électrique Fender', 'Guitare électrique haut de gamme pour les musiciens expérimentés', 7);
    await BienDatabaseHelper.insertBien('Harry Potter et la Coupe de Feu', 'Roman de la célèbre saga Harry Potter', 8);
    await BienDatabaseHelper.insertBien('Poussette Bugaboo', 'Poussette légère et facile à manœuvrer pour bébés', 9);
    await BienDatabaseHelper.insertBien('Tapis de yoga', 'Tapis de yoga antidérapant pour la pratique du yoga à domicile', 10);
  }

  static Future<void> insertBien(String nom, String description, int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.insert('Bien', {
      'Nom': nom,
      'description' : description,
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

  static Future<Map<String, dynamic>?> getBienByCategorie(int idCategorie) async {
    print('on est la avec $idCategorie');
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('Bien', where: 'ID_Categorie = ?', whereArgs: [idCategorie]) ?? [];
    print(result);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateBien(int id, String nom, String description, int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.update('Bien', {
      'Nom': nom,
      'description' : description,
      'ID_Categorie': idCategorie,
    }, where: 'ID_Bien = ?', whereArgs: [id]);
  }

  static Future<void> deleteBien(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.delete('Bien', where: 'ID_Bien = ?', whereArgs: [id]);
  }
}
