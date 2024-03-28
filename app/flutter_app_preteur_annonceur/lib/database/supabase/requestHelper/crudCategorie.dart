import 'package:supabase_flutter/supabase_flutter.dart';

class CategorieCrud {
  static Future<void> createCategorie(String nomCategorie, String descriptionCategorie) async {
    return await Supabase.instance.client
        .from('CATEGORIE')
        .insert({
          'nomc': nomCategorie,
          'descriptionc': descriptionCategorie,
        });
  }

  static Future<List<Map<String, dynamic>>?> fetchCategories() async {
    final response = await Supabase.instance.client
        .from('CATEGORIE')
        .select();

    if (response.isEmpty == true) {
      print('Erreur lors de la récupération des catégories !');
      return null;
    }

    return response;
  }

  static Future<void> updateCategorie(int idCategorie, String nomCategorie, String descriptionCategorie) async {
    return await Supabase.instance.client
        .from('CATEGORIE')
        .update({
          'nomc': nomCategorie,
          'descriptionc': descriptionCategorie,
        })
        .eq('idcategorie', idCategorie);
  }

  static Future<void> deleteCategorie(int idCategorie) async {
    return await Supabase.instance.client
        .from('CATEGORIE')
        .delete()
        .eq('idcategorie', idCategorie);
  }

  static Future<Map<String, dynamic>?> getCategorieById(int idCategorie) async {
  final response = await Supabase.instance.client
      .from('CATEGORIE')
      .select()
      .eq('idcategorie', idCategorie)
      .single();

  if (response.isEmpty) {
    print('Erreur lors de la récupération de la catégorie par ID !');
    return null;
  }

  return response;
}

static Future<List<Map<String, dynamic>>?> getCategorieByNom(String nomCategorie) async {
  final response = await Supabase.instance.client
      .from('CATEGORIE')
      .select()
      .eq('nomc', nomCategorie);

  if (response.isEmpty) {
    print('Erreur lors de la récupération de la catégorie par nom !');
    return null;
  }

  return response;
}

}
