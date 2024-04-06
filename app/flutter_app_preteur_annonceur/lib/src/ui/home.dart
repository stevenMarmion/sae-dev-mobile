import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/components/bottomnavigationbar.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final int? token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Map<String, dynamic>>?> _futureAnnonces;

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  Future<void> _loadAnnonces() async {
    _futureAnnonces = AnnonceCrud.fetchAnnonces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Bienvenue sur la page d'accueil",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Center(
          child: FutureBuilder<List<Map<String, dynamic>>?>(
            future: _futureAnnonces,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>>? annonces = snapshot.data;
                if (annonces == null || annonces.isEmpty) {
                  return const Center(child: Text('Aucune annonce trouvée'));
                } else {
                  return ListView.builder(
                    itemCount: annonces.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => _onAnnonceTapped(annonces[index]),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.subject, color: Colors.black),
                            title: Center(
                              child: Text(
                                annonces[index]['titrea'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text(
                              annonces[index]['description'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWrapper(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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

  void _onAnnonceTapped(Map<String, dynamic> annonce) {
    context.go('/home/announces/${annonce['idannonce']}?token=${widget.token}');
  }
}
