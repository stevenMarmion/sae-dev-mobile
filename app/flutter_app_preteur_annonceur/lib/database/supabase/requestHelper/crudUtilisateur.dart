import 'package:supabase_flutter/supabase_flutter.dart';

class UtilisateurCrud {
  static Future<void> createUtilisateur(String nom, String prenom, int age, String adresseMail, String mdp, String pseudo) async {
    return await Supabase.instance.client
        .from('UTILISATEUR')
        .insert({
          'nomu': nom,
          'prenomu': prenom,
          'ageu': age,
          'adressemail': adresseMail,
          'mdpu': mdp,
          'pseudou': pseudo,
        });
  }

  static Future<List<Map<String, dynamic>>?> fetchUtilisateurs() async {
    final response = await Supabase.instance.client
        .from('UTILISATEUR')
        .select();

    if (response.isEmpty == true) {
      print('Erreur lors de la récupération des utilisateurs !');
      return null;
    }

    return response;
  }

  static Future<void> updateUtilisateur(int idUtilisateur, String nom, String prenom, int age, String adresseMail, String mdp, String pseudo) async {
    return await Supabase.instance.client
        .from('UTILISATEUR')
        .update({
          'nomu': nom,
          'prenomu': prenom,
          'ageu': age,
          'adressemail': adresseMail,
          'mdpu': mdp,
          'pseudou': pseudo,
        })
        .eq('identifiantUtilisateur', idUtilisateur);
  }

  static Future<void> deleteUtilisateur(int idUtilisateur) async {
    return await Supabase.instance.client
        .from('UTILISATEUR')
        .delete()
        .eq('identifiantutilisateur', idUtilisateur);
  }

  static Future<PostgrestList?> fetchUtilisateurByPseudoAndPassword(String pseudo, String mdp) async {
    final response = await Supabase.instance.client
        .from('UTILISATEUR')
        .select()
        .eq('pseudou', pseudo)
        .eq('mdpu', mdp);
        
    if (response.isEmpty) {
      print('Utilisateur inexistant');
    }

    return response;
  }

  static Future<Map<String, dynamic>?> fetchUtilisateurById(int idUtilisateur) async {
    final response = await Supabase.instance.client
        .from('UTILISATEUR')
        .select()
        .eq('identifiantutilisateur', idUtilisateur)
        .single();

    if (response.isEmpty) {
      print('Erreur lors de la récupération de l\'utilisateur !');
      return null;
    }

    return response;
  }

}
