import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/providers/fire_auth_provider.dart';
import 'package:flutter_riverpod_base/commons/providers/user_data_provider.dart';
import 'package:flutter_riverpod_base/feature/admin/admin_nav.dart';
import 'package:flutter_riverpod_base/feature/user/home/user_home.dart';
import 'package:go_router/go_router.dart';

import '../commons/views/screens/splash.dart';
import '../feature/authentication/view/auth_view.dart';
import '../feature/home/view/home.dart';

Provider<GoRouter> routerConfigProvider = Provider((ref) {
  final authState = ref.watch(userIdProvider);
  final userData = ref.watch(userDataProvider);

  return GoRouter(
    initialLocation: AuthView.routePath,
    debugLogDiagnostics: true,
    redirect: (state, GoRouterState newState) {
      if (authState.value == null) {
        return AuthView.routePath;
      }
      if (authState.value != null) {
        if (userData.value != null) {
          if (userData.value!.type == "admin") {
            return AdminNav.routePath;
          } else {
            return UserHome.routePath;
          }
        }
      }
      return null;
    },
    refreshListenable: ref.watch(userIdValueNotifierProvider),
    routes: [
      GoRoute(
        path: AuthView.routePath,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthView();
        },
      ),
      GoRoute(
        path: SplashView.routePath,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: HomeView.routePath,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: AdminNav.routePath,
        builder: (BuildContext context, GoRouterState state) {
          return const AdminNav();
        },
      ),
      GoRoute(
        path: UserHome.routePath,
        builder: (BuildContext context, GoRouterState state) {
          return const UserHome();
        },
      ),
    ],
  );
});
