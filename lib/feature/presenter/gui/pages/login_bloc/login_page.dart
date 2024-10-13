import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/login_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/login_bloc/login_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../routers/app_routers.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginBloc = getIt<LoginPageBloc>();
  final logger = Logger();

  bool _obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initialLogin();
  }

  void _initialLogin() {
    _loginBloc.add(const GetLoginEvent());
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _loginMethod() {
    String usernameText = usernameController.text;
    String passwordText = passwordController.text;

    if (usernameText != "" && passwordText != "") {
      //this is the logic in events.
      _loginBloc
          .add(GetLoginEvent(params: LoginParams(usernameText, passwordText)));
    } else {
      showDialog(
          context: context,
          builder: (builder) {
            return CustomAlertDialog(
                colorMessage: Colors.red,
                title: "Login Erro",
                onPressedCloseBtn: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                    "Email, phone or Username is Empty or Password is empty"));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginPageBloc, LoginPageState>(
      bloc: _loginBloc,
      listener: (context, state) {
        logger.d(state);

        if (state is LoginSuccessState) {
          AutoRouter.of(context)
              .push(HomeNavigationRoute(uid: state.data?.uid));
        }

        if (state is LoginFirebaseErrorState) {
          showDialog(
              context: context,
              builder: (builder) {
                return CustomAlertDialog(
                    colorMessage: Colors.red,
                    title: "Database Error",
                    child: Text(state.message));
              });
        }
        if (state is LoginErrorState) {
          showDialog(
              context: context,
              builder: (builder) {
                return CustomAlertDialog(
                  colorMessage: Colors.red,
                  title: "Login Error",
                  onPressedCloseBtn: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(state.message),
                );
              });
        }

        if (state is LoginInternetErrorState) {
          showDialog(
              context: context,
              builder: (builder) {
                return CustomAlertDialog(
                    colorMessage: Colors.red,
                    title: "Internet Connection Error",
                    onPressedCloseBtn: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(state.message));
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    top: -100,
                    left: -200,
                    child: Transform.rotate(
                      angle: 0.3490,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2.0,
                        height: 250,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  // Bottom green rectangle
                  Positioned(
                    bottom: -100,
                    right: -200,
                    child: Transform.rotate(
                      angle: 0.3490,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2.0,
                        height: 250,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth > 600
                              ? 400
                              : constraints.maxWidth,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            // Logo
                            Image.asset(
                              'assets/logo.png',
                              key: const Key('logo'),
                              height: constraints.maxHeight * 0.3,
                            ),
                            const SizedBox(height: 20),

                            // Email/Phone/Username TextField
                            TextField(
                              key: const Key('emailField'),
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Email, Phone, Username',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password TextField
                            TextField(
                              key: const Key('passwordField'),
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                            const SizedBox(height: 10),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                key: const Key('forgotPasswordButton'),
                                onPressed: () {
                                  // Add forgot password functionality
                                },
                                child: const Text('Forgot?',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Login Button
                            ElevatedButton(
                              key: const Key('loginButton'),
                              onPressed: _loginMethod,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Log In'),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              key: Key('orDivider'),
                              children: [
                                Expanded(child: Divider(color: Colors.black)),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('Or'),
                                ),
                                Expanded(child: Divider(color: Colors.black)),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Continue with Google Button
                            OutlinedButton.icon(
                              key: const Key('googleLoginButton'),
                              onPressed: () {
                                // Add Google sign-in functionality
                              },
                              icon: Image.asset(
                                'assets/google_logo.png',
                                height: 24,
                              ),
                              label: const Text('Continue with Google'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign Up
                            TextButton(
                              key: const Key('signUpButton'),
                              onPressed: () {
                                // Add sign-up functionality

                                AutoRouter.of(context)
                                    .push(const RegistrationFormRoute());
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: "Don't have an Account? ",
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
