import 'package:flutter_app_preteur_annonceur/src/login_register/login.dart';
import 'package:flutter_app_preteur_annonceur/src/login_register/register.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
    initialLocation: '/login',
    // //refreshListenable: LoginPage(),
    // redirect: (context, state) {
    //   //final bool loggedInfo = LoginPage();
    //   if(!loggedInfo) {
    //     return '/sign-in';
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
      //     path: '/home',
      //     name: 'home',
      //     builder: (context, state) => const HomeScreen(),
      //     routes: <RouteBase>[
      //       GoRoute(
      //           path: 'pre-game',
      //           builder: (context, state) => const PreGamePage(),
      //           routes: <RouteBase>[
      //             GoRoute(
      //               path: 'play-game',
      //               builder: (context, state) {
      //                 final int niveau = int.parse(state.uri.queryParameters['niveau']!);
      //                 final String? nom = state.uri.queryParameters['player'];
      //                 return GamePage(niveau: niveau, player: '$nom');
      //               }
      //             ),
      //           ]
      //       ),
      //       GoRoute(
      //           path: 'view-scores',
      //           builder: (context, state) {
      //             return const ViewScores();
      //           }
      //       ),
      //       GoRoute(
      //           path: 'info',
      //           builder: (context, state) {
      //             return const RulesPage();
      //           }
      //       ),
      //     ]
      // ),
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