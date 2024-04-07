import 'package:supabase_flutter/supabase_flutter.dart';

class BienCrud {
  static Future<void> createBien(String nom, String description) async {
    return await Supabase.instance.client
        .from('BIEN')
        .insert({
          'nomb': nom,
          'descriptionbien': description,
        });
  }

  static Future<List<Map<String, dynamic>>?> fetchBiens() async {
    final response = await Supabase.instance.client
        .from('BIEN')
        .select();

    if (response.isEmpty == true) {
      print('Erreur lors de la récupération des biens !');
      return null;
    }

    return response;
  }

  static Future<void> updateBien(int idBien, String nom, String description) async {
    return await Supabase.instance.client
        .from('BIEN')
        .update({
          'nomb': nom,
          'descriptionbien': description,
        })
        .eq('IDBIEN', idBien);
  }

  static Future<void> deleteBien(int idBien) async {
    return await Supabase.instance.client
        .from('BIEN')
        .delete()
        .eq('IDBIEN', idBien);
  }

  static Future<Map<String, dynamic>?> getBienById(int idBien) async {
    final response = await Supabase.instance.client
        .from('BIEN')
        .select()
        .eq('IDBIEN', idBien)
        .single();

    if (response.isEmpty) {
      print('Erreur lors de la récupération du bien par ID !');
      return null;
    }

    return response;
  }

  static Future<List<Map<String, dynamic>>?> getBienByNom(String nomBien) async {
    final response = await Supabase.instance.client
        .from('BIEN')
        .select()
        .eq('nomb', nomBien);

    if (response.isEmpty) {
      print('Erreur lors de la récupération du bien par nom !');
      return null;
    }

    return response;
  }
}
