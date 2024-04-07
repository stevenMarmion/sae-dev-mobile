import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudBien.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudCategorie.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudEstPourvu.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudBien.dart';
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
  late Future<List<Map<String, dynamic>>?> _futureObjectsAssociated;
  int? _selectedBienIndex;

  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _futureAnnonce = _loadAnnonce();
    _futureObjectsAssociated = _getObjectsAssociatedWithAnnonce();
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
        int.parse(user?['token'] ?? '0')
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
                  const Text(
                    "Objets associés à cette annonce :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>?>(
                      future: _futureObjectsAssociated,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final objectsAssociated = snapshot.data;
                          return ListView.builder(
                            itemCount: objectsAssociated?.length ?? 0,
                            itemBuilder: (context, index) {
                              final object = objectsAssociated![index];
                              return FutureBuilder<List<Map<String, dynamic>>?>(
                                future: _getBienInfo(object['cle_bien']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final bienInfos = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: bienInfos.asMap().entries.map((entry) {
                                        final bienInfo = entry.value;
                                        return ListTile(
                                          title: Text(bienInfo['nomb'] ?? ''),
                                          subtitle: Text(bienInfo['descriptionbien'] ?? ''),
                                          leading: Radio<int>(
                                            value: object['cle_bien'],
                                            groupValue: _selectedBienIndex,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedBienIndex = value;
                                              });
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _validateSelection,
                    child: const Text('Valider'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> _getCategoryName(int? categoryId) async {
    print(categoryId);
    Map<String, dynamic>? rep = await CategorieCrud.getCategorieById(categoryId);
    return 'Catégorie ${rep!['nomc']}';
  }

  String _getStateName(int? stateId) {
    String res = '';
    switch (stateId) {
      case 1:
        res = 'Ouverte';
        break;
      
      case 2:
        res = 'Pourvue';
        break;
      
      case 3:
        res = 'Clôturée';
        break;
      
      case 4:
        res = 'En cours';
        break;
    }
    return res;
  }

  Future<List<Map<String, dynamic>>?> _getObjectsAssociatedWithAnnonce() async {
    final annonce = await _futureAnnonce;
    final idAnnonce = annonce?['cle_fonctionnelle'];
    List<Map<String, dynamic>>? listBiens = await EstPourvuCrud.getEstPourvuByAnnonce(idAnnonce);
    return listBiens;
  }

  Future<List<Map<String, dynamic>>?> _getBienInfo(int? cleBien) async {
    return await BienCrud.getBienByCle(cleBien!);
  }

  void _validateSelection() async {
    if (_selectedBienIndex != null) {
      await BienDatabaseHelper.setBienReserve(_selectedBienIndex!);
      await AnnonceCrud.setAnnonceEnCours(widget.cleFonctionnelleAnnonce);
      print('Bien sélectionné : $_selectedBienIndex');
    } else {
      print('Aucun bien sélectionné.');
    }
  }
}
