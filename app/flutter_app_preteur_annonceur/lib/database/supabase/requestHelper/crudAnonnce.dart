import 'package:supabase_flutter/supabase_flutter.dart';

class AnnonceCrud {
  static Future<void> createAnnonce(String titre, String description, String datedebut, int? idUtilisateur, int idCategorie, int idEtat, String dateCloture, int cleFonctionnelle) async {
    return await Supabase.instance.client
        .from('ANNONCE')
        .insert({
          'titrea': titre,
          'description': description,
          'datedebut': datedebut,
          'idu': idUtilisateur,
          'idc': idCategorie,
          'idetat': idEtat,
          'datecloture': dateCloture,
          'cle_fonctionnelle': cleFonctionnelle,
        });
  }

  static Future<List<Map<String, dynamic>>?> fetchAnnonces() async {
    final response = await Supabase.instance.client
        .from('ANNONCE')
        .select();

    if (response.isEmpty == true) {
      print('Erreur lors de la récupération des annonces !');
      return null;
    }

    return response;
  }

  static Future<void> updateAnnonce(int idAnnonce, String titre, String description, String datedebut, int idUtilisateur, int idCategorie, int idEtat, String dateCloture, int cleFonctionnelle) async {
    return await Supabase.instance.client
        .from('ANNONCE')
        .update({
          'titrea': titre,
          'description': description,
          'datedebut': datedebut,
          'idu': idUtilisateur,
          'idc': idCategorie,
          'idetat': idEtat,
          'datecloture': dateCloture,
          'cle_fonctionnelle': cleFonctionnelle,
        })
        .eq('idannonce', idAnnonce);
  }

  static Future<void> deleteAnnonce(int idAnnonce) async {
    return await Supabase.instance.client
        .from('ANNONCE')
        .delete()
        .eq('idannonce', idAnnonce);
  }

  static Future<List<Map<String, dynamic>>?> getAnnoncesByCategorie(int idCategorie) async {
    final response = await Supabase.instance.client
        .from('ANNONCE')
        .select()
        .eq('idc', idCategorie);

    if (response.isEmpty) {
      print('Erreur lors de la récupération des annonces par catégorie !');
      return null;
    }

    return response;
  }
}
