import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pack_n_deliver/apis/password_api.dart';
import 'package:pack_n_deliver/commons/dialog.dart';
import 'package:pack_n_deliver/core/providers.dart';
import 'package:pack_n_deliver/router/route_constants.dart';

final loginControllerProvider =
    StateNotifierProvider<LogInController, bool>((ref) {
  return LogInController(passwordApi: ref.read(passworAPIProvider));
});

class LogInController extends StateNotifier<bool> {
  final PasswordApi _passwordApi;

  LogInController({required PasswordApi passwordApi})
      : _passwordApi = passwordApi,
        super(false);

  Future<void> login({
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = true;
    final res = await _passwordApi.getPassword();
    state = false;

    res.fold(
      (failure) {
        textDialog(
            context, 'Error', 'Failed to fetch password: ${failure.message}');
      },
      (storedPassword) {
        if (password == storedPassword) {
          ref.read(authStateProvider.notifier).state = true;
          context.goNamed(RouteConstants.dashboard);
        } else {
          textDialog(context, 'Error', 'Incorrect password. Please try again.');
        }
      },
    );
  }
}
