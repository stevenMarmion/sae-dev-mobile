import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';

class ReservationsPage extends StatefulWidget {
  final int? token;

  const ReservationsPage({super.key, required this.token});

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  late Future<List<Map<String, dynamic>>?> _futureReservations;
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
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    _futureReservations = AnnonceCrud.fetchMesReservations(utilisateur!.getIdentifiantUtilisateur);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vos réservations"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Center(
          child: FutureBuilder<List<Map<String, dynamic>>?>(
            future: _futureReservations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>>? reservations = snapshot.data;
                if (reservations == null || reservations.isEmpty) {
                  return const Center(child: Text('Vous n\'avez aucune réservation.'));
                } else {
                  return ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => _onReservationTapped(reservations[index]),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          child: ListTile(
                            leading: const Icon(Icons.subject),
                            title: Center(
                              child: Text(
                                reservations[index]['titrea'] ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            subtitle: Text(
                              reservations[index]['description'] ?? '',
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
    );
  }

  void _onReservationTapped(Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clôturer la réservation"),
          content: const Text("Êtes-vous sûr de vouloir clôturer cette réservation ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cloturerReservation(reservation);
              },
              child: const Text("Clôturer"),
            ),
          ],
        );
      },
    );
  }

  void _cloturerReservation(Map<String, dynamic> reservation) async {
    await AnnonceCrud.cloturerAnnnonce(reservation['cle_fonctionnelle']);
    await AnnonceLocaleDatabaseHelper.setCloturer(reservation['cle_fonctionnelle']);
  }
}
