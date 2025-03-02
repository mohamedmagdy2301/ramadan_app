import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/azkary_app.dart';
import 'package:ramadan_app/features/settings/presentation/veiw/screens/settings_screen.dart';

import '../../features/home/presentation/view/screens/home_screen.dart';
import 'routes.dart';

abstract class AppRouter {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerState =
      GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get globalContext => navigatorKey.currentContext!;

  static final GoRouter appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.mainScaffold,
    // debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.mainScaffold,
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const MainScaffold(),
            ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: SettingsScreen(),
            ),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder:
            (context, state) => buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const HomeScreen(),
            ),
      ),
    ],
  );
}

CustomTransitionPage buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) => SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeIn)),
          ),
          child: child,
        ),
  );
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
  );
}
