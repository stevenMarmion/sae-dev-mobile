import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudBien.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudCategorie.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';

class AnnonceDetailsPage extends StatefulWidget {
  final int annonceId;
  final int? token;

  const AnnonceDetailsPage({super.key, required this.annonceId, required this.token});

  @override
  _AnnonceDetailsPageState createState() => _AnnonceDetailsPageState();
}

class _AnnonceDetailsPageState extends State<AnnonceDetailsPage> {
  late Future<Map<String, dynamic>?> _futureAnnonce;
  late Map<String, dynamic>? _futureCategorie;
  late Map<String, dynamic>? annonce;
  late String categorieName = '';
  List<Map<String, dynamic>?> _biens = [];
  Map<String, dynamic>? _selectedBien;

  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _loadAnnonce();
    _loadCategorie();
  }

  void _loadAnnonce() async {
    _futureAnnonce = AnnonceCrud.fetchAnnonceById(widget.annonceId);
  }

  Future<void> _loadCategorie() async {
    annonce = await AnnonceCrud.fetchAnnonceById(widget.annonceId);
    print(annonce);
    int? categorieId = annonce?['idc'];
    _futureCategorie = await CategorieCrud.getCategorieById(categorieId!);
    categorieName = _futureCategorie?['nomc'];
    _biens = await BienDatabaseHelper.getBienByCategorie(categorieId);
    setState(() {});
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
        title: const Text("Détails de l'annonce"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _futureAnnonce,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              Map<String, dynamic> annonce = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Titre de l'annonce:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(annonce['titrea']),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Description:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(annonce['description']),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Date de début:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(annonce['datedebut']),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Date de clôture:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(annonce['datecloture']),
                  const SizedBox(height: 16.0),
                  Text(
                    "Catégorie: $categorieName",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Sélectionnez le bien que vous souhaitez prêter:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _biens.length,
                      itemBuilder: (context, index) {
                        final bien = _biens[index];
                        return RadioListTile<Map<String, dynamic>?>(
                          title: Text(bien?['Nom'] ?? ''),
                          value: bien,
                          groupValue: _selectedBien,
                          onChanged: (selectedBien) {
                            setState(() {
                              _selectedBien = selectedBien;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Bien sélectionné: ${_selectedBien?['Nom'] ?? ""}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedBien != null) {
                        AnnonceCrud.pourvoirAnnonce(annonce['cle_fonctionnelle'], utilisateur!.getIdentifiantUtilisateur);
                        BienDatabaseHelper.setBienReserve(_selectedBien?['ID_Bien']);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Veuillez sélectionner un bien à prêter')),
                        );
                      }
                    },
                    child: const Text("Prêter"),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
