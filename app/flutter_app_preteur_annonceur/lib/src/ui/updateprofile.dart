import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';

class ProfileEditPage extends StatefulWidget {
  final int? token;

  const ProfileEditPage({Key? key, required this.token}) : super(key: key);

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

  String messageUpdate = '';

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
      body: SingleChildScrollView(
        child: utilisateur != null
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _nomController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _prenomController,
                        decoration: const InputDecoration(labelText: 'Prénom'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _ageController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _ageController.text = '${(DateTime.now().year - date.year)}';
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Date de naissance'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _adresseMailController,
                        decoration: const InputDecoration(labelText: 'Adresse e-mail'),
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(50),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            return regExp.hasMatch(newValue.text.trim()) ? newValue : oldValue;
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _mdpController,
                        decoration: const InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _pseudoController,
                        decoration: const InputDecoration(labelText: 'Pseudo'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _saveChanges();
                      },
                      child: const Text('Enregistrer les modifications'),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        messageUpdate,
                        style: const TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _saveChanges() async {
    int age = int.parse(_ageController.text);
    await UtilisateurCrud.updateUtilisateur(
      utilisateur!.identifiantUtilisateur,
      _nomController.text,
      _prenomController.text,
      age,
      _adresseMailController.text,
      _mdpController.text,
      _pseudoController.text,
    );
    setState(() {
      messageUpdate = 'Vos données ont été enregistrées';
    });
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
