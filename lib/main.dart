import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/router/router.dart';
import 'package:pack_n_deliver/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PackNDeliver',
      theme: AppTheme.appTheme,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}