import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/connexion_supabase.dart';
import 'package:flutter_app_preteur_annonceur/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.getDatabase();
    SupabaseConnexion.initaliseConnexion();

    return MaterialApp.router(
      title: 'Application - SAE',
      theme: ThemeData(
        colorScheme: const ColorScheme.light()
      ),
      routerConfig: router,
    );
  }
}