import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';

class PretsPage extends StatefulWidget {
  final int? token;

  const PretsPage({super.key, required this.token});

  @override
  _PretsPageState createState() => _PretsPageState();
}

class _PretsPageState extends State<PretsPage> {
  List<Map<String, dynamic>>? _annonces = [];
  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _fetchUser();
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
    _loadAnnonces();
  }

  void _loadAnnonces() async {
    print(utilisateur);
    if (utilisateur != null) {
      _annonces = await AnnonceCrud.getPretsByUser(utilisateur!.getIdentifiantUtilisateur);
      print(_annonces);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vos prêts"),
      ),
      body: _buildAnnoncesList(),
    );
  }

  Widget _buildAnnoncesList() {
    if (_annonces == null || _annonces!.isEmpty) {
      return const Center(
        child: Text(
          "Vous n'avez aucun prêt en cours.",
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _annonces!.length,
        itemBuilder: (context, index) {
          final annonce = _annonces![index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                annonce['titrea'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date de début: ${annonce['datedebut']}"),
                  Text("Date de clôture: ${annonce['datecloture']}"),
                  Text("Description: ${annonce['description']}"),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
