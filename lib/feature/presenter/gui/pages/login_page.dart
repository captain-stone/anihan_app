import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../routers/app_routers.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        const TextField(
                          key: Key('emailField'),
                          decoration: InputDecoration(
                            labelText: 'Email, Phone, Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password TextField
                        TextField(
                          key: const Key('passwordField'),
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
                          onPressed: () {
                            // Add login functionality

                            AutoRouter.of(context).push(HomeRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Log In'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          key: const Key('orDivider'),
                          children: const [
                            Expanded(child: Divider(color: Colors.black)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                .push(RegistrationFormRoute());
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
  }
}
