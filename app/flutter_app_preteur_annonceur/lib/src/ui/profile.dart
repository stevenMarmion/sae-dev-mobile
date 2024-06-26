import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/components/bottomnavigationbar.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  final int? token;

  const ProfilePage({super.key, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Compte'),
        ),
        body: utilisateur != null
            ? Center(
                child: ProfileContent(
                  imageUrl: 'url_iumage_pp', 
                  user: utilisateur,
                  token: widget.token
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      bottomNavigationBar: BottomNavigationBarWrapper(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      ),
    );
  }

    void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
    switch (value) {
      case 0:
        context.go('/home?token=${widget.token}');
        break;
      case 1:
        context.go('/search?token=${widget.token}');
        break;
      case 2:
        context.go('/post-announce?token=${widget.token}');
        break;
      case 3:
        context.go('/profile?token=${widget.token}');
        break;
    }
  }
}

class ProfileContent extends StatelessWidget {
  final String imageUrl;
  final Utilisateur? user;
  final int? token;

  const ProfileContent({super.key, required this.imageUrl, required this.user, this.token});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 75,
        ),
        const SizedBox(height: 20),
        Text(
          user?.pseudo ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.go('/profile/update-profile?token=$token');
          },
          child: const Text('Mes coordonnées'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.go('/profile/mes-biens?token=$token');
          },
          child: const Text('Mes biens actuels'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.go('/profile/mes-prets?token=$token');
          },
          child: const Text('Mes prêts actuels'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.go('/profile/mes-reservations?token=$token');
          },
          child: const Text('Mes réservations actuelles'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.go('/profile/mes-annonces?token=$token');
          },
          child: const Text('Mes annonces actuelles'),
        ),
      ],
    );
  }
}

