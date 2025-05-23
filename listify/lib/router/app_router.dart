import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/providers/auth_provider.dart';
import 'package:listify/features/auth/presentation/screens/forgot_password.dart';
import 'package:listify/features/main_container/presentation/screens/main_container.dart';
import '../features/auth/presentation/screens/auth_selection.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/home/presentation/screens/home.dart';
import './initial_route_helper.dart';
import '../features/welcome/presentation/screens/welcome_screen.dart';

class AppRouter {
  // Define route paths
  static const String homeRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String authSelectionRoute = '/auth-selection';
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String forgotPasswordRoute = '/forgot-password';

  // List of protected routes (requires user to be signed in)
  static final List<GoRoute> protectedRoutes = [
    GoRoute(
      path: homeRoute,
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const MainContainer(),
    ),
    // Add more protected routes here
  ];

  // Create the router with authentication and redirection logic
  static Future<GoRouter> createRouter(WidgetRef ref) async {
    // Determine the initial route (e.g., home or welcome)
    final initialRoute = await InitialRouteHelper.getInitialRoute(
      homeRoute,
      welcomeRoute,
    );

    return GoRouter(
      initialLocation: initialRoute, // Set the initial route
      redirect: (context, state) {
        // Check the user's authentication state
        final authState = ref.read(authStateProvider).asData?.value;

        // Check if the user is trying to access a protected route
        final isAccessingProtectedRoute = protectedRoutes.any(
          (route) => state.uri.toString() == route.path,
        );

        // Redirect to auth-selection if not signed in and accessing a protected route
        if (isAccessingProtectedRoute && authState == null) {
          return authSelectionRoute;
        }
        return null; // No redirection
      },
      // List of public routes (not requires user to be signed in)
      routes: <RouteBase>[
        // Welcome screen route
        GoRoute(
          path: welcomeRoute,
          name: 'welcome',
          builder:
              (BuildContext context, GoRouterState state) =>
                  const WelcomeScreen(),
        ),

        // Auth selection screen route
        GoRoute(
          path: authSelectionRoute,
          name: 'auth_selection',
          builder:
              (BuildContext context, GoRouterState state) =>
                  const AuthSelection(),
        ),

        // Sign-up screen route
        GoRoute(
          path: signUpRoute,
          name: "sign_up",
          builder:
              (BuildContext context, GoRouterState state) => SignUpScreen(),
        ),

        // Sign-in screen route
        GoRoute(
          path: signInRoute,
          name: 'sign_in',
          builder:
              (BuildContext context, GoRouterState state) => SignInScreen(),
        ),

        // Forgot Password screen route
        GoRoute(
          path: forgotPasswordRoute,
          name: 'forgot_password',
          builder:
              (BuildContext context, GoRouterState state) =>
                  ForgotPasswordScreen(),
        ),

        // Include all protected routes
        ...protectedRoutes,
      ],
    );
  }
}
