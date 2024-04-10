import 'package:flutter_app_preteur_annonceur/src/login_register/login.dart';
import 'package:flutter_app_preteur_annonceur/src/login_register/register.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/detailannoncelocal.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/detailannounce.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/home.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/mesannonces.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/mesbiens.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/mesprets.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/mesreservations.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/postannounce.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/profile.dart';
import 'package:flutter_app_preteur_annonceur/src/ui/updateprofile.dart';
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
            return const LoginPage();
          }
      ),
      GoRoute(
          path: '/sign-in',
          builder: (context, state) {
            return RegisterPage();
          }
      ),
      GoRoute(
          path: '/profile',
          builder: (context, state) {
            int? token = int.tryParse(state.uri.queryParameters['token']!);
            return ProfilePage(token: token);
          },
          routes: <RouteBase>[
            GoRoute(
                path: 'update-profile',
                builder: (context, state) {
                  int? token = int.tryParse(state.uri.queryParameters['token']!);
                  return ProfileEditPage(token: token);
                },
              ),
              GoRoute(
                path: 'mes-biens',
                builder: (context, state) {
                  int? token = int.tryParse(state.uri.queryParameters['token']!);
                  return AllBiensPage(token: token);
                },
              ),
              GoRoute(
                path: 'mes-prets',
                builder: (context, state) {
                  int? token = int.tryParse(state.uri.queryParameters['token']!);
                  return PretsPage(token: token);
                },
              ),
              GoRoute(
                path: 'mes-reservations',
                builder: (context, state) {
                  int? token = int.tryParse(state.uri.queryParameters['token']!);
                  return ReservationsPage(token: token);
                },
              ),
              GoRoute(
                path: 'mes-annonces',
                builder: (context, state) {
                  int? token = int.tryParse(state.uri.queryParameters['token']!);
                  return AnnonceListPage(token: token);
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters["id"]!);
                      int? token = int.tryParse(state.uri.queryParameters['token']!);
                      return AnnonceDetailsWidget(cleFonctionnelleAnnonce: id, token: token);
                    },
                  ),
                ]
              )
            ]
      ),
      GoRoute(
          path: '/post-announce',
          builder: (context, state) {
            int? token = int.tryParse(state.uri.queryParameters['token']!);
            return AnnonceCreationPage(token: token);
          },
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
            int? token = int.tryParse(state.uri.queryParameters['token']!);
            return HomePage(token: token);
          },
          routes: <RouteBase>[
            GoRoute(
                path: 'announces/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters["id"]!);
                  int? token = int.tryParse(state.uri.queryParameters['token']!);
                  return AnnonceDetailsPage(annonceId: id, token: token);
                },
            ),
          ]
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
