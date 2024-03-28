import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final LoginInfo loginInfo;

  AppRouter({required this.loginInfo});

  get router => _router;

  late final _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/home',
      refreshListenable: loginInfo,
      redirect: (context, state) {
        final bool loggedInfo = loginInfo.logged;
        if(!loggedInfo) {
          return '/login';
        }
        return null; // signifie la route par défaut que l'on a demandé
      },
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
              return const LoginView();
            }
        ),
        GoRoute(
            path: '/sign-in',
            builder: (context, state) {
              return const SignInView();
            }
        ),
        GoRoute(
            path: '/search',
            builder: (context, state) {
              return const SearchView();
            }
        ),
        GoRoute(
            path: '/post-announce',
            builder: (context, state) {
              return const PostAnnounceView();
            }
        ),
        GoRoute(
            path: '/profile',
            builder: (context, state) {
              return const ProfileView();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'settings',
                  builder: (context, state) {
                    return const SettingsView();
                  },
                )
              ]
        ),
        GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) {
              return const HomeView();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'details/:id',
                  builder: (context, state) {
                    final id = state.pathParameters["id"];
                    return const DetailsView(id);
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
}
