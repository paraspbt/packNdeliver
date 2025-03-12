import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pack_n_deliver/controller/log_in_controller.dart';
import 'package:pack_n_deliver/view/dashboard_page.dart';
import 'package:pack_n_deliver/view/log_in_page.dart';
import 'package:pack_n_deliver/router/route_constants.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: RouteConstants.login,
        path: '/login',
        builder: (context, state) => const LogInPage(),
      ),
      GoRoute(
        name: RouteConstants.dashboard,
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = ref.read(authStateProvider);
      if (state.matchedLocation == '/dashboard' && !isAuthenticated) {
        return '/login';
      }
      if (state.matchedLocation == '/login' && isAuthenticated) {
        return '/dashboard';
      }
      return null;
    },
  );
});
