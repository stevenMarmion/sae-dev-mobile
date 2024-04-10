import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/utils/token.dart';
import 'package:go_router/go_router.dart';
import 'package:postgrest/src/types.dart';
import '../../database/supabase/requestHelper/crudUtilisateur.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  String? _accountAlreadyExists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("AnnonceConnect"),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Créer votre compte',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Pseudo',
                    ),
                  ),
                ),
              ),
              if (_accountAlreadyExists != null)
                Text(
                  _accountAlreadyExists!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_passwordController.text != _confirmPasswordController.text) {
                    setState(() {
                      _errorMessage = 'Les mots de passe ne correspondent pas.';
                    });
                  } else {
                    setState(() {
                      _errorMessage = null;
                    });
                    String pseudo = _usernameController.text;
                    String mdp = _passwordController.text;
                    PostgrestList? rep = await UtilisateurCrud.fetchUtilisateurByPseudoAndPassword(pseudo, mdp);
                    if (rep!.isNotEmpty) {
                      setState(() {
                        _accountAlreadyExists = "Ce pseudo existe déjà, modifiez-le !";
                    });
                    } else {
                        setState(() {
                          _accountAlreadyExists = null;
                        });
                        int token = TokenGenerator.generateToken();
                        await UtilisateurCrud.createUtilisateur('', '', -1, '', mdp, pseudo, token);
                        context.go('/home?token=$token');
                    }
                  }
                },
                child: const Text("S'inscrire"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Retour au menu de connexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
