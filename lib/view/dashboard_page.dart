import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/controller/log_in_controller.dart';

class DashboardPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const DashboardPage());
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final sessionData = ref.read(sessionStateProvider);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Session: ${sessionData.session}'),
            Text('ReactToken: ${sessionData.reactToken}'),
            Text('Csrf: ${sessionData.csrf}'),
          ],
        ),
      ),
    );
  }
}
