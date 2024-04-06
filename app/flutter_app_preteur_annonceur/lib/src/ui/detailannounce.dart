import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudBien.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudCategorie.dart';

class AnnonceDetailsPage extends StatefulWidget {
  final int annonceId;

  const AnnonceDetailsPage({super.key, required this.annonceId});

  @override
  _AnnonceDetailsPageState createState() => _AnnonceDetailsPageState();
}

class _AnnonceDetailsPageState extends State<AnnonceDetailsPage> {
  late Future<Map<String, dynamic>?> _futureAnnonce;
  late Future<Map<String, dynamic>?> _futureCategorie;
  late Map<String, dynamic>? annonce;
  late String categorieName = '';
  Map<String, dynamic>? _bienSelectionne;

  @override
  void initState() {
    super.initState();
    _loadAnnonce();
    _futureCategorie = _loadCategorie();
  }

  void _loadAnnonce() async {
    _futureAnnonce = AnnonceCrud.fetchAnnonceById(widget.annonceId);
  }

  Future<Map<String, dynamic>?> _loadCategorie() async {
    annonce = await AnnonceCrud.fetchAnnonceById(widget.annonceId);
    int? categorieId = annonce?['idc'];
    print(categorieId);
    _bienSelectionne = await BienDatabaseHelper.getBienByCategorie(categorieId!);
    print(_bienSelectionne);
    return await CategorieCrud.getCategorieById(categorieId);
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
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _futureCategorie,
                    builder: (context, categorieSnapshot) {
                      if (categorieSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (categorieSnapshot.hasError) {
                        return Text('Erreur: ${categorieSnapshot.error}');
                      } else {
                        Map<String, dynamic>? categorie = categorieSnapshot.data;
                        categorieName = categorie?['nomc'] ?? 'Inconnu';
                        return Text(
                          "Catégorie: $categorieName",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Sélectionnez le bien que vous souhaitez prêter:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _bienSelectionne != null ? 1 : 0,
                      itemBuilder: (context, index) {
                        final bien = _bienSelectionne!;
                        return RadioListTile<Map<String, dynamic>>(
                          title: Text(bien['nom']),
                          value: bien,
                          groupValue: _bienSelectionne,
                          onChanged: (selectedBien) {
                            setState(() {
                              _bienSelectionne = selectedBien;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_bienSelectionne != null) {
                        AnnonceCrud.updateAnnonce(
                          annonce['idannonce'],
                          annonce['titrea'],
                          annonce['description'],
                          annonce['datedebut'],
                          annonce['idu'],
                          annonce['idc'],
                          2,
                          annonce['datecloture'],
                          annonce['cle_fonctionnelle'],
                        );
                        AnnonceLocaleDatabaseHelper.updateAnnonce(
                          annonce['idannonce'],
                          annonce['titrea'],
                          annonce['description'],
                          annonce['datedebut'],
                          annonce['idu'],
                          annonce['idc'],
                          2,
                          annonce['datecloture'],
                          annonce['cle_fonctionnelle'],
                        );
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
