import 'package:supabase_flutter/supabase_flutter.dart';

class EtatCrud {
  static Future<void> createEtat(String nom) async {
    return await Supabase.instance.client
        .from('ETAT')
        .insert({
          'nome': nom,
        });
  }

  static Future<List<Map<String, dynamic>>?> fetchEtats() async {
    final response = await Supabase.instance.client
        .from('ETAT')
        .select();

    if (response.isEmpty == true) {
      print('Erreur lors de la récupération des états !');
      return null;
    }

    return response;
  }

  static Future<void> updateEtat(int idEtat, String nom) async {
    return await Supabase.instance.client
        .from('ETAT')
        .update({
          'nome': nom,
        })
        .eq('IDE', idEtat);
  }

  static Future<void> deleteEtat(int idEtat) async {
    return await Supabase.instance.client
        .from('ETAT')
        .delete()
        .eq('IDE', idEtat);
  }

  static Future<Map<String, dynamic>?> getEtatById(int idEtat) async {
  final response = await Supabase.instance.client
      .from('ETAT')
      .select()
      .eq('ide', idEtat)
      .single();

  if (response.isEmpty) {
    print('Erreur lors de la récupération de l\'état par ID !');
    return null;
  }

  return response;
}

static Future<List<Map<String, dynamic>>?> getEtatByNom(String nometat) async {
  final response = await Supabase.instance.client
      .from('ETAT')
      .select()
      .eq('nome', nometat);

  if (response.isEmpty) {
    print('Erreur lors de la récupération de l\'état par nom !');
    return null;
  }

  return response;
}

}
