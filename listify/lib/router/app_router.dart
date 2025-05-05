import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/providers/auth_provider.dart';
import '../features/auth/presentation/screens/auth_selection.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/home/presentation/screens/home.dart';
import './initial_route_helper.dart';
import '../features/welcome/presentation/screens/welcome_screen.dart';

class AppRouter {
  static const String homeRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String authSelectionRoute = '/auth-selection';
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';

  static final List<GoRoute> protectedRoutes = [
    GoRoute(
      path: homeRoute,
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const Home(),
    ),

    // Add more protected routes here (To access these routes, User needs to sign in)
  ];

  static Future<GoRouter> createRouter(WidgetRef ref) async {
    final initialRoute =
        await InitialRouteHelper.getInitialRoute(homeRoute, welcomeRoute);

    return GoRouter(
      initialLocation: initialRoute,
      redirect: (context, state) {
        // Use the authStateProvider to check if the user is signed in
        final authState = ref.read(authStateProvider).asData?.value;

        final isAccessingProtectedRoute =
            protectedRoutes.any((route) => state.uri.toString() == route.path);

        if (isAccessingProtectedRoute && authState == null) {
          return authSelectionRoute; // Redirect to auth-selection page if not signed in
        }
        return null; // No redirection
      },
      routes: <RouteBase>[
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

        GoRoute(
          path: signUpRoute,
          name: "sign_up",
          builder: (BuildContext context, GoRouterState state) =>
              SignUpScreen(),
        ),

        GoRoute(
          path: signInRoute,
          name: 'sign_in',
          builder: (BuildContext context, GoRouterState state) =>
              SignInScreen(),
        ),

        // Include protected routes
        ...protectedRoutes,
      ],
    );
  }
}