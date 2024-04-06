import 'package:supabase_flutter/supabase_flutter.dart';

class AnnonceCrud {
  static Future<void> pourvoirAnnonce(int cleFonctionnelle, int? idUtilisateur) async {
    return await Supabase.instance.client
        .from('ANNONCE')
        .update({
          'pourvuPar': idUtilisateur,
          'idetat': 2,
        })
        .eq('cle_fonctionnelle', cleFonctionnelle);
  }

  static Future<void> ouvrirAnnonce(int cleFonctionnelle) async {
    return await Supabase.instance.client
        .from('ANNONCE')
        .update({
          'pourvuPar': null,
          'idetat': 1,
        })
        .eq('cle_fonctionnelle', cleFonctionnelle);
  }

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
          'pourvuPar' : null
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

  static Future<List<Map<String, dynamic>>?> fetchMesReservations(int? idU) async {
    final response = await Supabase.instance.client
        .from('ANNONCE')
        .select()
        .eq('idu', idU!)
        .eq('idetat', 2);
    return response;
  }

  static Future<void> updateAnnonce(int idAnnonce, String titre, String description, String datedebut, int idUtilisateur, int idCategorie, int idEtat, String dateCloture, int cleFonctionnelle, int? pourvuPar) async {
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
          'pourvuPar' : pourvuPar
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

  static Future<List<Map<String, dynamic>>?> getAnnoncesByUser(int? idU) async {
    final response = await Supabase.instance.client
        .from('ANNONCE')
        .select()
        .eq('idu', idU!);

    if (response.isEmpty) {
      print('Erreur lors de la récupération des annonces par catégorie !');
      return null;
    }

    return response;
  }

  
  static Future<List<Map<String, dynamic>>?> getPretsByUser(int? idU) async {
    print('on est la');
    final response = await Supabase.instance.client
        .from('ANNONCE')
        .select()
        .eq('pourvuPar', idU!);

    return response;
  }

  static Future<Map<String, dynamic>?> fetchAnnonceById(int id) async {
    List<Map<String, dynamic>>? annonces = await Supabase.instance.client
        .from('ANNONCE')
        .select()
        .eq('idannonce', id);

    return annonces.isNotEmpty == true ? annonces[0] : null;
  }

  static Future<Map<String, dynamic>?> fetchAnnonceByfonctionnalKey(int cleFonctionnelle) async {
    List<Map<String, dynamic>>? annonces = await Supabase.instance.client
        .from('ANNONCE')
        .select()
        .eq('cle_fonctionnelle', cleFonctionnelle);

    return annonces.isNotEmpty == true ? annonces[0] : null;
  }
}
