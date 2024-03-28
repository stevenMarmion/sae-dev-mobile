import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectionIndex = 0;

  List<String> routes = [
    '/home',
    '/search',
    '/post-announce',
    '/profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Bienvenue sur la page d'accueil"),
        ),
      ),
      body: const Center(
        child: Text("Contenu de la page d'accueil"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectionIndex,
        onTap: _onItemTapped,
        selectedFontSize: 14,
        fixedColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: "Rechercher",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: Colors.black),
            label: "Poster",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box, color: Colors.black),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectionIndex = value;
    });
    context.go(routes[value]);
  }
}
