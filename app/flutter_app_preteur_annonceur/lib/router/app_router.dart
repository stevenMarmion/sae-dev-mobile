import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_preteur_annonceur/src/app.dart';
import 'package:flutter_app_preteur_annonceur/src/login_register/login.dart';
import 'package:flutter_app_preteur_annonceur/src/login_register/register.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/home.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
    //navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    //refreshListenable: loginInfo,
    // redirect: (context, state) {
    //   final bool loggedInfo = loginInfo.logged;
    //   if(!loggedInfo) {
    //     return '/login';
    //   }
    //   return null; // signifie la route par défaut que l'on a demandé
    // },
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          redirect: (context, state) {
            return '/home';
          }
      ),
      GoRoute(
          path: '/login',
          builder: (context, state) {
            return LoginPage();
          }
      ),
      GoRoute(
          path: '/sign-in',
          builder: (context, state) {
            return RegisterPage();
          }
      ),
      // GoRoute(
      //     path: '/search',
      //     builder: (context, state) {
      //       return const SearchView();
      //     }
      // ),
      // GoRoute(
      //     path: '/post-announce',
      //     builder: (context, state) {
      //       return const PostAnnounceView();
      //     }
      // ),
      // GoRoute(
      //     path: '/profile',
      //     builder: (context, state) {
      //       return const ProfileView();
      //     },
      //     routes: <RouteBase>[
      //       GoRoute(
      //           path: 'settings',
      //           builder: (context, state) {
      //             return const SettingsView();
      //           },
      //         )
      //       ]
      // ),
      GoRoute(
          path: '/home',
          builder: (context, state) {
            return const HomePage();
          },
      //     routes: <RouteBase>[
      //       GoRoute(
      //           path: 'details/:id',
      //           builder: (context, state) {
      //             final id = state.pathParameters["id"];
      //             return const DetailsView(id);
      //           },
      //       ),
      //     ]
      ),
      // GoRoute(
      //   path: '/details/:id',
      //   name: 'details-on-id',
      //   builder: (context, state) {
      //     final id = state.pathParameters["id"];
      //     return DetailScreen(id: int.parse(id!));
      //   },
      // ),
      // GoRoute(
      //   path: '/details',
      //   name: 'details',
      //   builder: (context, state) {
      //     final id = state.uri.queryParameters['search'];
      //     return DetailScreen(id: int.parse(id!));
      //   },
      // ),
    ]
);
