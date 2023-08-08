import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/router/router.dart';

import '../../../common/colors.dart';
import '../controller/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  dynamic email;
  dynamic pass;
  loginUser() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();

      ref
          .watch(authControllerProvider.notifier)
          .loginUser(email: email, password: pass, context: context);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greenColor),
                    ),
                  ),
                  onSaved: (emailVal) {
                    email = emailVal;
                  },
                  validator: (emailVal) {
                    bool result = emailVal!.contains(
                      RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                    );
                    return result ? null : "enter a valid Email";
                  }),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor),
                  ),
                ),
                onSaved: (passVal) {
                  pass = passVal;
                },
                validator: (passVal) {
                  return passVal!.length >= 6
                      ? null
                      : "Password must be greater than 6";
                },
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(AppRoutes.forgotPassword.name);
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                //* increase the size of the button
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 50),
                    backgroundColor: greenColor),
                onPressed: () async {
                  loginUser();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
