import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top green rectangle
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Help button in the top right corner
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      // Action for help button
                    },
                  ),
                ),

                // Logo at the top
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 62.0),
                  child: Image.asset('assets/logo.png', height: 100),
                ),

                // Phone number field
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),

                // Next button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Next'),
                    ),
                  ),
                ),

                // Or divider with lines on both sides
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Or"),
                      ),
                      Expanded(child: Divider(color: Colors.black)),
                    ],
                  ),
                ),

                // Google Sign Up button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/google_logo.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text('Sign Up with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Login link
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to login screen
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an Account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Terms and Privacy Policy
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'By signing up, you agree to ANIHAN\'s ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
