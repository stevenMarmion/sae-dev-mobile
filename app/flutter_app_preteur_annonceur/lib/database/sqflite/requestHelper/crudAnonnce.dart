import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class AnnonceLocaleDatabaseHelper {
  
  static Future<void> initSkeleton(Database? db) async {
    await db?.execute('''
      CREATE TABLE IF NOT EXISTS ANNONCE (
        idAnnonce INTEGER PRIMARY KEY,
        titreA TEXT NOT NULL,
        description TEXT NOT NULL,
        datedebut TEXT NOT NULL,
        IDU INTEGER NOT NULL,
        IDC INTEGER NOT NULL,
        idEtat INTEGER NOT NULL,
        dateCloture TEXT NOT NULL,
        cle_fonctionnelle INTEGER NOT NULL,
        FOREIGN KEY (IDU) REFERENCES UTILISATEUR(identifiantUtilisateur),
        FOREIGN KEY (IDC) REFERENCES CATEGORIE(idCategorie),
        FOREIGN KEY (idEtat) REFERENCES ETAT(IDE)
      )
    ''');
  }

  static Future<void> insertAnnonce(String titre, String description, String datedebut, int? idUtilisateur, int idCategorie, int idEtat, String dateCloture, int cleFonctionnelle) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.insert('ANNONCE', {
      'titreA': titre,
      'description': description,
      'datedebut': datedebut,
      'IDU': idUtilisateur,
      'IDC': idCategorie,
      'idEtat': idEtat,
      'dateCloture': dateCloture,
      'cle_fonctionnelle': cleFonctionnelle,
    });
  }

  static Future<List<Map<String, dynamic>>?> getAnnonces() async {
    Database? db = await DatabaseHelper.getDatabase();
    return await db?.query('ANNONCE');
  }

  static Future<Map<String, dynamic>?> getAnnonceById(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    List<Map<String, dynamic>> result = await db?.query('ANNONCE', where: 'idAnnonce = ?', whereArgs: [id]) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateAnnonce(int id, String titre, String description, String datedebut, int idUtilisateur, int idCategorie, int idEtat, String dateCloture, int cleFonctionnelle) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.update('ANNONCE', {
      'titreA': titre,
      'description': description,
      'datedebut': datedebut,
      'IDU': idUtilisateur,
      'IDC': idCategorie,
      'idEtat': idEtat,
      'dateCloture': dateCloture,
      'cle_fonctionnelle': cleFonctionnelle,
    }, where: 'idAnnonce = ?', whereArgs: [id]);
  }

  static Future<void> deleteAnnonce(int id) async {
    Database? db = await DatabaseHelper.getDatabase();
    await db?.delete('ANNONCE', where: 'idAnnonce = ?', whereArgs: [id]);
  }
}
