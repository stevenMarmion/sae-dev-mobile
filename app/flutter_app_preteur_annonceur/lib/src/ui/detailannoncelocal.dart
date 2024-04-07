import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudCategorie.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';

class AnnonceDetailsWidget extends StatefulWidget {
  final int cleFonctionnelleAnnonce;
  final int? token;

  const AnnonceDetailsWidget({super.key, required this.cleFonctionnelleAnnonce, required this.token});

  @override
  _AnnonceDetailsWidgetState createState() => _AnnonceDetailsWidgetState();
}

class _AnnonceDetailsWidgetState extends State<AnnonceDetailsWidget> {
  late Future<Map<String, dynamic>?> _futureAnnonce;
  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _futureAnnonce = _loadAnnonce();
  }

  Future<Map<String, dynamic>?> _loadAnnonce() async {
    return await AnnonceCrud.fetchAnnonceByfonctionnalKey(widget.cleFonctionnelleAnnonce);
  }

  
  Future<void> _fetchUser() async {
    final user = await UtilisateurCrud.fetchUtilisateurByToken(widget.token!);
    setState(() {
      Utilisateur jsonUser = Utilisateur(
        user?['identifiantutilisateur'],
        user?['nomu'],
        user?['prenomu'],
        user?['ageu'],
        user?['adressemail'],
        user?['mdpu'],
        user?['pseudou'],
        int.parse(user?['token'])
      ); 
      utilisateur = jsonUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _futureAnnonce,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final annonce = snapshot.data;
              return Text(annonce?['titrea'] ?? '');
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _futureAnnonce,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final annonce = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description : ${annonce?['description'] ?? ''}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Date de début : ${annonce?['datedebut'] ?? ''}"),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: _getCategoryName(annonce?['idc']),
                    builder: (context, snapshot) {
                      return Text("Catégorie : ${snapshot.data}");
                    },
                  ),
                  const SizedBox(height: 8),
                  Text("État : ${_getStateName(annonce?['idetat'])}"),
                  const SizedBox(height: 8),
                  Text("Date de clôture : ${annonce?['datecloture'] ?? ''}"),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> _getCategoryName(int? categoryId) async {
    Map<String, dynamic>? rep = await CategorieCrud.getCategorieById(categoryId);
    return 'Catégorie ${rep!['nomc']}';
  }

  String _getStateName(int? stateId) {
    return stateId == 1 ? 'Ouverte' : 'Pourvue';
  }
}
