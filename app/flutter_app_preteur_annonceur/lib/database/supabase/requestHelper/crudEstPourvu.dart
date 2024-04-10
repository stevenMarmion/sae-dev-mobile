import 'package:supabase_flutter/supabase_flutter.dart';

class EstPourvuCrud {
  static Future<void> createEstPourvu(int cleAnnonce, int cleBien) async {
    return await Supabase.instance.client
        .from('EST_POURVU')
        .insert({
          'cle_annonce': cleAnnonce,
          'cle_bien': cleBien,
        });
  }

  static Future<List<Map<String, dynamic>>?> fetchEstPourvus() async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select();

    if (response.isEmpty == true) {
      print('Erreur lors de la récupération des éléments EST_POURVU !');
      return null;
    }

    return response;
  }

  static Future<void> deleteEstPourvu(int idPourvu) async {
    return await Supabase.instance.client
        .from('EST_POURVU')
        .delete()
        .eq('idpourvu', idPourvu);
  }

  static Future<Map<String, dynamic>?> getEstPourvuById(int idPourvu) async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select()
        .eq('idpourvu', idPourvu)
        .single();

    if (response.isEmpty) {
      print('Erreur lors de la récupération de l\'élément EST_POURVU par IDPourvu !');
      return null;
    }

    return response;
  }

  static Future<List<Map<String, dynamic>>?> getEstPourvuByAnnonce(int cleAnnonce) async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select()
        .eq('cle_annonce', cleAnnonce);

    if (response.isEmpty) {
      print('Erreur lors de la récupération des éléments EST_POURVU par CleAnnonce !');
      return null;
    }
    print(response);
    return response;
  }

  static Future<List<Map<String, dynamic>>?> getEstPourvuByBien(int cleBien) async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select()
        .eq('cle_bien', cleBien);

    if (response.isEmpty) {
      print('Erreur lors de la récupération des éléments EST_POURVU par CleBien !');
      return null;
    }

    return response;
  }
}
