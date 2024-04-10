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
        estReserve INTEGER,
        cle_fonctionnelle INTEGER,
        FOREIGN KEY (ID_Categorie) REFERENCES CATEGORIE(ID_Categorie)
      )
    ''');
    await db?.execute('''
        INSERT OR IGNORE INTO Bien(ID_Bien, Nom, description, ID_Categorie, estReserve, cle_fonctionnelle) VALUES
        (1, 'iPhone 13 Pro', 'Smartphone haut de gamme avec caméra professionnelle', 1, 0, 1), 
        (2, 'Réfrigérateur Samsung', 'Réfrigérateur avec technologie avancée de conservation des aliments', 2, 0, 2),
        (3, 'Perceuse Bosch', 'Perceuse électrique sans fil avec batterie rechargeable', 3, 0, 3),
        (4, 'Vélo de montagne', 'Vélo tout terrain pour les amateurs de sports extrêmes', 4, 0, 4),
        (5, 'Chemise Ralph Lauren', 'Chemise élégante et confortable pour hommes', 5, 0, 5),
        (6, 'Canapé d''angle en cuir', 'Canapé spacieux et confortable pour le salon', 6, 0, 6),
        (7, 'Guitare électrique Fender', 'Guitare électrique haut de gamme pour les musiciens expérimentés', 7, 0, 7),
        (8, 'Harry Potter et la Coupe de Feu', 'Roman de la célèbre saga Harry Potter', 8, 0, 8),
        (9, 'Poussette Bugaboo', 'Poussette légère et facile à manœuvrer pour bébés', 9, 0, 9),
        (10, 'Tapis de yoga', 'Tapis de yoga antidérapant pour la pratique du yoga à domicile', 10, 0, 10)
    ''');
  }

  static Future<void> insertBien(String nom, String description, int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.rawInsert('''
      INSERT INTO Bien(Nom, description, ID_Categorie, estReserve) VALUES(?, ?, ?, ?)
    ''', [nom, description, idCategorie, 0]);
  }

  static Future<List<Map<String, dynamic>>?> getBiens() async {
    Database? db = await DatabaseHelper.getDatabase();
    return await db?.rawQuery('''
      SELECT * FROM Bien
    ''');
  }

  static Future<Map<String, dynamic>?> getBienById(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.rawQuery('''
      SELECT * FROM Bien WHERE ID_Bien = ?
    ''', [id]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>?>> getBienByCategorie(int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.rawQuery('''
      SELECT * FROM Bien WHERE ID_Categorie = ?
    ''', [idCategorie]) ?? [];
    return result;
  }

  static Future<Map<String, dynamic>?> getBienReserve() async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.rawQuery('''
      SELECT * FROM Bien WHERE estReserve = ?
    ''', [1]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<Map<String, dynamic>?> getBienPasReserve() async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.rawQuery('''
      SELECT * FROM Bien WHERE estReserve = ?
    ''', [0]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> setBienReserve(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.rawUpdate('''
      UPDATE Bien SET estReserve = ? WHERE ID_Bien = ?
    ''', [1, id]);
  }

  static Future<void> setBienPasReserve(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.rawUpdate('''
      UPDATE Bien SET estReserve = ? WHERE ID_Bien = ?
    ''', [0, id]);
  }

  static Future<void> updateBien(int id, String nom, String description, int idCategorie) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.rawUpdate('''
      UPDATE Bien SET Nom = ?, description = ?, ID_Categorie = ? WHERE ID_Bien = ?
    ''', [nom, description, idCategorie, id]);
  }

  static Future<void> deleteBien(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.rawDelete('''
      DELETE FROM Bien WHERE ID_Bien = ?
    ''', [id]);
  }
}
