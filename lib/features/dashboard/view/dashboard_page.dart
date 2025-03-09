import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const DashboardPage());
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Success'),
      ),
    );
  }
}
