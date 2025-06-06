import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/providers/auth_provider.dart';
import 'package:listify/features/auth/presentation/screens/change_password.dart';
import 'package:listify/features/auth/presentation/screens/forgot_password.dart';
import 'package:listify/features/item/presentation/screens/create_items_user.dart';
import 'package:listify/features/item/presentation/screens/view_all_items.dart';
import 'package:listify/features/list_item_management/presentation/screens/list_selection.dart';
import 'package:listify/features/list_item_management/presentation/screens/quantity_selection.dart';

import 'package:listify/features/list_item_management/presentation/screens/list_sharing_screen.dart';
import 'package:listify/features/list_item_management/presentation/screens/quantity_update.dart';

import 'package:listify/features/notifications/presentation/screens/notification_screen.dart';
import 'package:listify/features/list_item_management/presentation/screens/add_list_items.dart';
import 'package:listify/features/main_container/presentation/screens/main_container.dart';
import 'package:listify/features/settings/presentation/screens/delete_account.dart';
import '../core/Models/Item.dart';
import '../core/Models/ListItem.dart';
import '../features/auth/presentation/screens/auth_selection.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
// ignore: unused_import
import '../features/home/presentation/screens/home.dart';
import '../features/pick_location/presentation/screens/pick_location_screen.dart';
import './initial_route_helper.dart';
import '../features/welcome/presentation/screens/welcome_screen.dart';
import 'package:listify/main.dart';
import 'package:listify/features/profile/profile.dart';
import 'package:listify/features/profile/setting.dart';
import 'package:listify/features/categories/categories_view.dart';
import 'package:listify/features/categories/category_view.dart';

class AppRouter {
  // Define route paths
  static const String homeRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String authSelectionRoute = '/auth-selection';
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String notificationRoute = '/notification';
  static const String addListItemsRoute = '/add-list-items';
  static const String quantitySelectionRoute = '/quantity-selection';
  static const String listSelectionRoute = '/list-selection';
  static const String listSharingRoute = '/list-sharing';
  static const String pickLocationRoute = '/pick_location';
  static const String ViewAllItemsRoute = '/view_all_items';
  static const String CreateItemsUserRoute = '/create_items_user';
  static const String quantityUpdateRoute = '/quantity-update';
  static const String deleteAccountRoute = '/delete-account';
  static const String changePasswordRoute = '/change-password';
  static const String mainContainerRoute = '/main-container';

  // List of protected routes (requires user to be signed in)
  static final List<GoRoute> protectedRoutes = [
    GoRoute(
      path: homeRoute,
      name: 'home',
      builder:
          (BuildContext context, GoRouterState state) => const MainContainer(),
      // (BuildContext context, GoRouterState state) => const ListSharingScreen(),
    ),

    GoRoute(
      path: notificationRoute,
      name: 'notification',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return NotificationScreen(
          title: args?['title'],
          body: args?['body'],
          data: args?['data'],
        );
      },
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
      navigatorKey: rootNavigatorKey,
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

        // Add list items screen route
        GoRoute(
          path: addListItemsRoute,
          name: 'add_list_items',
          builder:
              (BuildContext context, GoRouterState state) => AddListItems(),
        ),

        // List sharing screen route
        GoRoute(
          path: listSharingRoute,
          name: 'list_sharing',
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>?;
            return ListSharingScreen(
              listId: data?['listId'],
              listName: data?['listName'],
            );
          },
        ),

        // Quantity selection screen route
        GoRoute(
          path: quantitySelectionRoute,
          name: 'quantity_selection',
          builder: (BuildContext context, GoRouterState state) {
            final item = state.extra as Item;
            return QuantitySelection(item: item);
          },
        ),

        GoRoute(
          path: listSelectionRoute,
          name: 'list_selection',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;
            final item = extra['item'] as Item;
            final quantity = extra['quantity'] as String;
            return ListSelection(item: item, quantity: quantity);
          },
        ),
        // pick location screen route
        GoRoute(
          path: pickLocationRoute,
          name: 'pick_location',
          builder:
              (BuildContext context, GoRouterState state) =>
                  PickLocationScreen(),
        ),

        //categories route
        GoRoute(
          path: '/categories',
          name:'categories_view',
          builder:
              (BuildContext context, GoRouterState state) =>
              CategoriesViewScreen(),
        ),

        // pick location screen route
        GoRoute(
          path: ViewAllItemsRoute,
          name: 'view_all_items',
          builder:
              (BuildContext context, GoRouterState state) =>
                  ViewAllItemsScreen(),
        ),

        GoRoute(
          path: CreateItemsUserRoute,
          name: 'create_items_user',
          builder:
              (BuildContext context, GoRouterState state) => CreateItemsUser(),
        ),

        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => ProfileScreen(),
        ),

        GoRoute(
          path: '/setting',
          name: 'setting',
          builder: (context, state) => Settings(),
        ),

        GoRoute(
          path: quantityUpdateRoute,
          name: 'quantity_update',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;
            final listItem = extra['listItem'] as ListItem;
            final listId = extra['listId'] as String;
            return QuantityUpdate(listItem: listItem, listId: listId);
          },
        ),

        GoRoute(
          path: deleteAccountRoute,
          name: 'delete-account',
          builder:
              (BuildContext context, GoRouterState state) => DeleteAccountPage(),
        ),

        GoRoute(
          path: changePasswordRoute,
          name: 'change-password',
          builder:
              (BuildContext context, GoRouterState state) => ChangePasswordScreen(),
        ),

        GoRoute(
          path: mainContainerRoute,
          name: 'main-container',
          builder:
              (BuildContext context, GoRouterState state) => MainContainer(),
        ),
        // Include all protected routes
        ...protectedRoutes,
      ],
    );
  }
}
