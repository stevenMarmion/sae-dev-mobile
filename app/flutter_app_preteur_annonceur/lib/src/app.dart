import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/database/sqflite/connexion_sqflite.dart';
import 'package:flutter_app_preteur_annonceur/database/supabase/connexion_supabase.dart';
import 'package:flutter_app_preteur_annonceur/router/app_router.dart';
import 'package:flutter_app_preteur_annonceur/src/login_register/login.dart';
// ignore: depend_on_referenced_packages
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    //return MultiProvider(
        //providers: const [
            // ChangeNotifierProvider(
            //   create: (context) => LoginInfo()
            // ),
            // ProxyProvider<LoginInfo, AppRouter>(
            //     update: (context, login, _) => AppRouter(loginInfo: login)
            // ),
        //],
        //child:const Builder(
              // builder: ((context) {
              //   // ignore: unused_local_variable
              //   final GoRouter router = Provider.of<AppRouter>(context).router;
              //   return MaterialApp.router(
              //     title: 'Application - Nombre mystère',
              //     theme: ThemeData(
              //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
              //     ),
              //     routerConfig: AppRouter(loginInfo: Provider.of<LoginInfo>(context)).router,
              //   );
              // }
            //),
          //),
    //);
  }
}