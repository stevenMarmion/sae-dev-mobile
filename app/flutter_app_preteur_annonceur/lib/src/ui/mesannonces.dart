import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';
import 'package:go_router/go_router.dart';

class AnnonceListPage extends StatefulWidget {
  final int? token;

  const AnnonceListPage({super.key, required this.token});

  @override
  _AnnonceListPageState createState() => _AnnonceListPageState();
}

class _AnnonceListPageState extends State<AnnonceListPage> {
  late Future<List<Map<String, dynamic>>?> _futureAnnonces;
  int _selectedState = 1;
  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
    _fetchUser();
  }

  Future<void> _loadAnnonces() async {
    _futureAnnonces = AnnonceCrud.getAnnoncesByEtat(_selectedState);
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
        int.parse(user?['token']),
      );
      utilisateur = jsonUser;
    });
  }

  void _deleteAnnonce(int idAnnonce) async {
    await AnnonceCrud.deleteAnnonce(idAnnonce);
    _loadAnnonces();
  }

  void _editAnnonce(int idAnnonce, String titre, String description, int idEtat, String datedebut, String dateCloture) async {
    await AnnonceCrud.updateAnnonceBis(idAnnonce, titre, description, datedebut, dateCloture, idEtat);
    _loadAnnonces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Annonces"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: _selectedState,
              onChanged: (value) {
                setState(() {
                  _selectedState = value!;
                  _loadAnnonces();
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text("Annonces Ouvertes"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("Annonces Pourvues"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("Annonces Clôturées"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: _futureAnnonces,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>>? annonces = snapshot.data;
                    if (annonces == null || annonces.isEmpty) {
                      return const Center(child: Text('Aucune annonce trouvée'));
                    } else {
                      return ListView.builder(
                        itemCount: annonces.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(annonces[index]['titrea'] ?? ''),
                              subtitle: Text(annonces[index]['description'] ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => _buildEditAnnonceDialog(annonces[index]),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteAnnonce(annonces[index]['cle_fonctionnelle']);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                int cleFonctionnelle = annonces[index]['cle_fonctionnelle'];
                                context.go('/profile/mes-annonces/details/$cleFonctionnelle?token=${widget.token}');
                              },
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditAnnonceDialog(Map<String, dynamic> annonce) {
    TextEditingController titreController = TextEditingController(text: annonce['titrea']);
    TextEditingController descriptionController = TextEditingController(text: annonce['description']);
    TextEditingController datedebutController = TextEditingController(text: annonce['datedebut']);
    TextEditingController dateClotureController = TextEditingController(text: annonce['datecloture']);
    int selectedEtat = annonce['idetat'];

    return AlertDialog(
      title: const Text("Modifier l'annonce"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titreController,
            decoration: const InputDecoration(labelText: 'Titre'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: datedebutController,
            readOnly: true,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                datedebutController.text = picked.toString();
              }
            },
            decoration: const InputDecoration(labelText: 'Date de début'),
          ),
          TextField(
            controller: dateClotureController,
            readOnly: true,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                dateClotureController.text = picked.toString();
              }
            },
            decoration: const InputDecoration(labelText: 'Date de clôture'),
          ),
          DropdownButton<int>(
            value: selectedEtat,
            onChanged: (value) {
              setState(() {
                selectedEtat = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text("Ouverte"),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text("Pourvue"),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text("Clôturée"),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            _editAnnonce(
              annonce['idannonce'],
              titreController.text,
              descriptionController.text,
              selectedEtat,
              datedebutController.text,
              dateClotureController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
