import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/features/auth/provider/district_provider.dart';
import '../../../common/colors.dart';
import '../../../router/router.dart';
import '../controller/auth_controller.dart';
import '../provider/loading_notifier.dart';
import '../widgets/google_sign_in_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  var name;
  var email;
  var pass;
  var phone;

  @override
  Widget build(BuildContext context) {
    final String selectedDistrict =
        ref.watch(registerDistrictSelectingNotifierProvider);
    void validRegister() async {
      if (_registerKey.currentState!.validate()) {
        ref.read(loadingProvider.notifier).state = true;
        _registerKey.currentState!.save();
        await ref.read(authControllerProvider.notifier).registerUser(
            district: selectedDistrict,
            phoneNumber: phone,
            name: name,
            email: email,
            password: pass,
            contexts: context);

        await Future.delayed(const Duration(seconds: 5));

        ref.watch(loadingProvider.notifier).state = false;
      }
    }

    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20, left: 20),
                child: const Text('Register',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
              Form(
                  key: _registerKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: greenColor),
                                ),
                                hintText: "Email",
                                border: OutlineInputBorder()),
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
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greenColor),
                              ),
                              hintText: " Your Name",
                              border: OutlineInputBorder()),
                          onSaved: (nameVal) {
                            name = nameVal;
                          },
                          validator: (nameVal) {
                            return nameVal!.isNotEmpty
                                ? null
                                : "Please Enter Your Name";
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greenColor),
                              ),
                              hintText: " Your Phone Number",
                              border: OutlineInputBorder()),
                          onSaved: (phoneVal) {
                            phone = phoneVal;
                          },
                          validator: (phoneVal) {
                            return phoneVal!.length <= 11
                                ? null
                                : "Invalid Number";
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: greenColor),
                            ),
                            hintText: "Password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          onSaved: (passVal) {
                            pass = passVal;
                          },
                          validator: (passVal) {
                            return passVal!.length > 6
                                ? null
                                : "Password must be greater than 6";
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      "Please Select Your City :",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton(
                      value: selectedDistrict,
                      items: const [
                        DropdownMenuItem(value: "Dhaka", child: Text("Dhaka")),
                        DropdownMenuItem(
                            value: "Chittagong", child: Text("Chittagong")),
                      ],
                      onChanged: (value) {
                        ref
                            .read(registerDistrictSelectingNotifierProvider
                                .notifier)
                            .changeDistrict(selectedDistrict: value!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 60),
                      backgroundColor: Colors.black),
                  onPressed: () => validRegister(),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: greenColor),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(child: SizedBox(width: 220, child: GoogleButton())),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account?"),
                  InkWell(
                    onTap: () {
                      context.goNamed(AppRoutes.login.name);
                    },
                    child: const Text(
                      ' Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
