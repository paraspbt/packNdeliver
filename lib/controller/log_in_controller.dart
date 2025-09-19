import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pack_n_deliver/apis/website_api.dart';
import 'package:pack_n_deliver/apis/get_session_api.dart';
import 'package:pack_n_deliver/apis/password_api.dart';
import 'package:pack_n_deliver/commons/dialog.dart';
import 'package:pack_n_deliver/models/session_data.dart';
import 'package:pack_n_deliver/router/route_constants.dart';

final authStateProvider = StateProvider<bool>((ref) => false);

final sessionStateProvider =
    StateNotifierProvider<SessionState, SessionData>((ref) {
  return SessionState();
});

class SessionState extends StateNotifier<SessionData> {
  SessionState() : super(SessionData(reactToken: "", session: "", csrf: ""));
  void update(SessionData sessionData) {
    state = sessionData;
  }
}

final loginControllerProvider =
    StateNotifierProvider<LogInController, bool>((ref) {
  return LogInController(
      passwordApi: ref.read(passworAPIProvider),
      getSessionApi: ref.read(getSessionApiProvider),
      ref: ref);
});

class LogInController extends StateNotifier<bool> {
  final PasswordApi _passwordApi;
  final GetSessionApi _getSessionApi;
  final Ref _ref;
  LogInController({
    required PasswordApi passwordApi,
    required GetSessionApi getSessionApi,
    required Ref ref,
  })  : _passwordApi = passwordApi,
        _getSessionApi = getSessionApi,
        _ref = ref,
        super(false);

  Future<void> login({
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _passwordApi.getPassword();
    res.fold(
      (failure) {
        state = false;
        textDialog(
            context, 'Error', 'Failed to fetch password: ${failure.message}');
      },
      (storedPassword) async {
        if (password == storedPassword) {
          final res2 = await _getSessionApi.call();
          state = false;
          res2.fold((l) {
            textDialog(
                context, 'Error', 'Failed to get Session Data: ${l.message}');
          }, (r) {
            _ref.read(sessionStateProvider.notifier).update(r);
            _ref.read(websiteApiProvider).getOrdersData();
            _ref.read(authStateProvider.notifier).update((state) => true);
            context.goNamed(RouteConstants.dashboard);
          });
        } else {
          state = false;
          textDialog(context, 'Error', 'Incorrect password. Please try again.');
        }
      },
    );
  }
}
