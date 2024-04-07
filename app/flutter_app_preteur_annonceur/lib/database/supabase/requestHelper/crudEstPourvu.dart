import 'package:supabase_flutter/supabase_flutter.dart';

class EstPourvuCrud {
  static Future<void> createEstPourvu(int idAnnonce, int idBien, int cleFonctionnelle) async {
    return await Supabase.instance.client
        .from('EST_POURVU')
        .insert({
          'ida': idAnnonce,
          'idb': idBien,
          'cle': cleFonctionnelle
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

  static Future<void> deleteEstPourvu(int idAnnonce, int idBien) async {
    return await Supabase.instance.client
        .from('EST_POURVU')
        .delete()
        .eq('ida', idAnnonce)
        .eq('idb', idBien);
  }

  static Future<Map<String, dynamic>?> getEstPourvuById(int cle, int idBien) async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select()
        .eq('cle', cle)
        .eq('idb', idBien)
        .single();

    if (response.isEmpty) {
      print('Erreur lors de la récupération de l\'élément EST_POURVU par IDA et IDB !');
      return null;
    }

    return response;
  }

  static Future<List<Map<String, dynamic>>?> getEstPourvuByAnnonce(int cle) async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select()
        .eq('cle', cle);

    if (response.isEmpty) {
      print('Erreur lors de la récupération des éléments EST_POURVU par IDA !');
      return null;
    }

    return response;
  }

  static Future<List<Map<String, dynamic>>?> getEstPourvuByBien(int idBien) async {
    final response = await Supabase.instance.client
        .from('EST_POURVU')
        .select()
        .eq('idb', idBien);

    if (response.isEmpty) {
      print('Erreur lors de la récupération des éléments EST_POURVU par IDB !');
      return null;
    }

    return response;
  }
}
