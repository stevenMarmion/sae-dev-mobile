import 'package:supabase_flutter/supabase_flutter.dart';

class BienCrud {
  static Future<void> createBien(String nom, String description, int cle_bien) async {
    print(nom);
    print(description);
    return await Supabase.instance.client
        .from('BIEN')
        .insert({
          'nombien': nom,
          'descriptionbien': description,
          'cle_bien': cle_bien
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
          'nombien': nom,
          'descriptionbien': description,
        })
        .eq('IDBIEN', idBien);
  }

  static Future<void> deleteBien(int idBien) async {
    return await Supabase.instance.client
        .from('BIEN')
        .delete()
        .eq('idbien', idBien);
  }

  static Future<Map<String, dynamic>?> getBienById(int idBien) async {
    final response = await Supabase.instance.client
        .from('BIEN')
        .select()
        .eq('idbien', idBien)
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

  static Future<List<Map<String, dynamic>>?> getBienByCle(int cle) async {
    final response = await Supabase.instance.client
        .from('BIEN')
        .select()
        .eq('cle_bien', cle);

    if (response.isEmpty) {
      print('Erreur lors de la récupération du bien par nom !');
      return null;
    }

    return response;
  }
}
