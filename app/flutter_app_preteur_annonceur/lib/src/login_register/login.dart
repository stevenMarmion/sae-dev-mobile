import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:go_router/go_router.dart';
import 'package:postgrest/src/types.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _unknowAccountMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('AnnonceConnect'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Connectez-vous à votre compte',
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
              if (_unknowAccountMessage != null)
                Text(
                  _unknowAccountMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String pseudo = _usernameController.text;
                  String mdp = _passwordController.text;
                  PostgrestList? rep = await UtilisateurCrud.fetchUtilisateurByPseudoAndPassword(pseudo, mdp);
                  int token = int.parse(rep?[0]['token']);
                    if (rep!.isEmpty) {
                      setState(() {
                        _unknowAccountMessage = "Vous n'avez pas de compte, veuillez vous en créer un !";
                      });
                    } else {
                      setState(() {
                        _unknowAccountMessage = null;
                      });
                      context.go('/home?token=$token');
                    }
                },
                child: const Text('Se connecter'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go('/sign-in');
                },
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
