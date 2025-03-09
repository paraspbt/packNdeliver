import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/commons/app_button.dart';
import 'package:pack_n_deliver/commons/input_field.dart';
import 'package:pack_n_deliver/features/login/controller/log_in_controller.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogIn() {
    ref.read(loginControllerProvider.notifier).login(
          password: passwordController.text,
          context: context,
          ref: ref,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Column(
                      children: [
                        InputField(
                          hintText: 'Enter Password',
                          controller: passwordController,
                          isRequired: true,
                          maxLines: 1,
                        ),
                        AppButton(
                          buttonText: 'Log In',
                          onPressed: onLogIn,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
