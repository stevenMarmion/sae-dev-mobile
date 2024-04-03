import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';

class ProfileEditPage extends StatefulWidget {
  final int? token;

  const ProfileEditPage({super.key, required this.token});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Utilisateur? utilisateur;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _adresseMailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final user = await UtilisateurCrud.fetchUtilisateurByToken(widget.token!);
    setState(() {
      utilisateur = Utilisateur.fromJson(user!);
      _nomController.text = utilisateur!.nom ?? '';
      _prenomController.text = utilisateur!.prenom ?? '';
      _ageController.text = utilisateur!.age == -1 ? '' : utilisateur!.age.toString();
      _adresseMailController.text = utilisateur!.adresseMail ?? '';
      _mdpController.text = utilisateur!.mdp ?? '';
      _pseudoController.text = utilisateur!.pseudo ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
      ),
      body: utilisateur != null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: NetworkImage('url_de_l_image'),
                    radius: 75,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    utilisateur!.pseudo ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),
                  TextField(
                    controller: _prenomController,
                    decoration: const InputDecoration(labelText: 'Prénom'),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Âge'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _adresseMailController,
                    decoration: const InputDecoration(labelText: 'Adresse e-mail'),
                  ),
                  TextField(
                    controller: _mdpController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _pseudoController,
                    decoration: const InputDecoration(labelText: 'Pseudo'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _saveChanges();
                    },
                    child: const Text('Enregistrer les modifications'),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _saveChanges() async {
    await UtilisateurCrud.updateUtilisateur(
      utilisateur!.identifiantUtilisateur,
      _nomController.text, 
      _prenomController.text, 
      int.parse(_ageController.text), 
      _adresseMailController.text, 
      _mdpController.text, 
      _pseudoController.text
    );
    // Vous pouvez ajouter ici la logique pour enregistrer les modifications dans la base de données
    // Utilisez les valeurs dans _nomController.text, _prenomController.text, etc.
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _ageController.dispose();
    _adresseMailController.dispose();
    _mdpController.dispose();
    _pseudoController.dispose();
    super.dispose();
  }
}
