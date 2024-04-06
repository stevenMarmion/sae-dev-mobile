import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudBien.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/requestHelper/crudCategorie.dart';

class AllBiensPage extends StatefulWidget {
  final int? token;

  const AllBiensPage({super.key, required this.token});

  @override
  _AllBiensPageState createState() => _AllBiensPageState();
}

class _AllBiensPageState extends State<AllBiensPage> {
  List<Map<String, dynamic>>? _allBiens = [];
  List<Map<String, dynamic>>? _biensByCategory = [];
  List<Map<String, dynamic>>? _categories = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadAllBiens();
    _loadCategories();
  }

  void _loadAllBiens() async {
    _allBiens = await BienDatabaseHelper.getBiens();
    setState(() {});
  }

  void _loadCategories() async {
    _categories = await CategorieDatabaseHelper.getCategories();
    setState(() {});
  }

  void _filterBiensByCategory(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _biensByCategory = _allBiens
          ?.where((bien) => bien['ID_Categorie'] == categoryId)
          .toList();
    });
  }

  Future<void> _ajouterBien() async {
    final nomController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un bien'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await BienDatabaseHelper.insertBien(
                  nomController.text,
                  descriptionController.text,
                  _selectedCategoryId ?? 1,
                );
                _loadAllBiens();
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _modifierBien(int id) async {
    final bien = await BienDatabaseHelper.getBienById(id);
    if (bien != null) {
      final nomController = TextEditingController(text: bien['Nom']);
      final descriptionController =
          TextEditingController(text: bien['description']);

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Modifier un bien'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await BienDatabaseHelper.updateBien(
                    id,
                    nomController.text,
                    descriptionController.text,
                    bien['ID_Categorie'],
                  );
                  _loadAllBiens();
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _supprimerBien(int id) async {
    await BienDatabaseHelper.deleteBien(id);
    _loadAllBiens();
  }

  String _getEtatReservation(bool estReserve) {
    return estReserve ? "Est réservé" : "N'est pas réservé";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tous les biens"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Choisissez une catégorie pour afficher les biens:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          _categories != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<int>(
                    value: _selectedCategoryId,
                    onChanged: (categoryId) {
                      _filterBiensByCategory(categoryId!);
                    },
                    items: _categories!
                        .map((category) => DropdownMenuItem<int>(
                              value: category['ID_Categorie'],
                              child: Text(
                                category['Nom_Categorie'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ))
                        .toList(),
                  ),
                )
              : const CircularProgressIndicator(),
          Expanded(
            child: _biensByCategory != null && _biensByCategory!.isNotEmpty
                ? ListView.builder(
                    itemCount: _biensByCategory?.length,
                    itemBuilder: (context, index) {
                      final bien = _biensByCategory![index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 4.0,
                        child: ListTile(
                          title: Text(
                            bien['Nom'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bien['description'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                _getEtatReservation(bien['estReserve'] == 1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: bien['estReserve'] == 1
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _modifierBien(bien['ID_Bien']);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  _supprimerBien(bien['ID_Bien']);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Aucun bien à afficher',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterBien,
        tooltip: 'Ajouter un bien',
        child: const Icon(Icons.add),
      ),
    );
  }
}
