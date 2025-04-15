import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mad_group_project/features/home/presentation/screens/home.dart';

import './initial_route_helper.dart';
import '../features/welcome/presentation/screens/welcome_screen.dart';

import 'package:mad_group_project/features/auth/presentation/screens/auth_selection.dart';

class AppRouter {
  static const String homeRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String authSelectionRoute = '/auth_selection';
  static const String signInRoute = '/sign_in';

  // Simulated authentication state
  static bool isSignedIn = true;

  // Define protected routes in a list
  static final List<GoRoute> protectedRoutes = [
    GoRoute(
      path: homeRoute,
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const Home(),
    )

    // Add more protected routes here
  ];

  static Future<GoRouter> createRouter() async {
    final initialRoute =
        await InitialRouteHelper.getInitialRoute(homeRoute, welcomeRoute);

    return GoRouter(
      initialLocation: initialRoute,
      redirect: (context, state) {
        // Redirect logic for authentication
        final isAccessingProtectedRoute =
            protectedRoutes.any((route) => state.uri.toString() == route.path);
        if (isAccessingProtectedRoute && !isSignedIn) {
          return authSelectionRoute; // Redirect to auth-selection page if not signed in
        }
        return null; // No redirection
      },
      routes: <RouteBase>[
        // Public Routes
        GoRoute(
          path: welcomeRoute,
          name: 'welcome',
          builder: (BuildContext context, GoRouterState state) =>
              const WelcomeScreen(),
        ),

        GoRoute(
          path: authSelectionRoute,
          name: 'auth_selection',
          builder: (BuildContext context, GoRouterState state) =>
              const AuthSelection(),
        ),

        // Include protected routes
        ...protectedRoutes,
      ],
    );
  }
}
