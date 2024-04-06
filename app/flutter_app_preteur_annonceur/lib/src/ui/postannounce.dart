import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudAnonnce.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudCategorie.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/requestHelper/crudUtilisateur.dart';
import 'package:flutter_app_preteur_annonceur/models/user.dart';
import 'package:flutter_app_preteur_annonceur/utils/token.dart';

class AnnonceCreationPage extends StatefulWidget {
  final int? token;

  const AnnonceCreationPage({super.key, required this.token});

  @override
  _AnnonceCreationPageState createState() => _AnnonceCreationPageState();
}

class _AnnonceCreationPageState extends State<AnnonceCreationPage> {
  late TextEditingController _titreController;
  late TextEditingController _descriptionController;
  late TextEditingController _idCategorieController;
  late TextEditingController _dateDebutController;
  late TextEditingController _dateClotureController;

  Utilisateur? utilisateur;

  DateTime? _selectedDebutDate;
  DateTime? _selectedClotureDate;

  String messageAjout = '';

  List<Map<String, dynamic>>? categories = [];

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _titreController = TextEditingController();
    _descriptionController = TextEditingController();
    _idCategorieController = TextEditingController();
    _dateDebutController = TextEditingController();
    _dateClotureController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>>? fetchedCategories = await CategorieCrud.fetchCategories();
    if (fetchedCategories != null) {
      setState(() {
        categories = fetchedCategories;
        _idCategorieController.text = categories![0]['idcategorie'].toString();
      });
    }
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
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _idCategorieController.dispose();
    _dateDebutController.dispose();
    _dateClotureController.dispose();
    super.dispose();
  }

  Future<void> _selectDebutDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: _selectedClotureDate ?? DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDebutDate = pickedDate;
        _dateDebutController.text = _selectedDebutDate!.toString();
      });
    }
  }

  Future<void> _selectClotureDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDebutDate ?? DateTime.now(),
      firstDate: _selectedDebutDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedClotureDate = pickedDate;
        _dateClotureController.text = _selectedClotureDate!.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création d\'annonce'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(labelText: 'Titre de l\'annonce'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                _selectDebutDate(context);
              },
              child: IgnorePointer(
                child: TextField(
                  controller: _dateDebutController,
                  decoration: const InputDecoration(
                    labelText: 'Date de début',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _idCategorieController.text,
              onChanged: (newValue) {
                setState(() {
                  _idCategorieController.text = newValue!;
                });
              },
              items: categories?.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['idcategorie'].toString(),
                  child: Text(category['nomc']),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Catégorie'),
            ),
            const SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                _selectClotureDate(context);
              },
              child: IgnorePointer(
                child: TextField(
                  controller: _dateClotureController,
                  decoration: const InputDecoration(
                    labelText: 'Date de clôture',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_checkFields()) {
                    _createAnnonce();
                  }
                },
                child: const Text('Créer l\'annonce'),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Text(
                messageAjout,
                style: TextStyle(color: messageAjout.contains('ajoutée') ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkFields() {
    if (_titreController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dateDebutController.text.isEmpty ||
        _dateClotureController.text.isEmpty) {
      setState(() {
        messageAjout = 'Tous les champs doivent être remplis !';
      });
      return false;
    }
    return true;
  }

  void _createAnnonce() async {
    String titre = _titreController.text;
    String description = _descriptionController.text;
    String dateDebut = _dateDebutController.text;
    int idCategorie = int.parse(_idCategorieController.text);
    int idEtat = 1;
    String dateCloture = _dateClotureController.text;
    int cleFonctionnelle = TokenGenerator.generateToken();

    AnnonceCrud.createAnnonce(titre, description, dateDebut, utilisateur!.getIdentifiantUtilisateur, idCategorie, idEtat, dateCloture, cleFonctionnelle);
    AnnonceLocaleDatabaseHelper.insertAnnonce(titre, description, dateDebut, utilisateur!.getIdentifiantUtilisateur, idCategorie, idEtat, dateCloture, cleFonctionnelle);
    setState(() {
      messageAjout = 'Annonce ajoutée avec succès !';
    });
  }
}
