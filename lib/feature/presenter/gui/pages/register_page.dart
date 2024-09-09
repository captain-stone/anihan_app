import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormStatePage();
}

class _RegistrationFormStatePage extends State<RegistrationFormPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: _height,
          width: _width,
          child: Stack(
            children: [
              // Top green rectangle
              Positioned(
                top: -100,
                left: -200,
                child: Transform.rotate(
                  angle: 0.3490,
                  child: Container(
                    width: _width * 2.0,
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
                    width: _width * 2.0,
                    height: 250,
                    color: Colors.green,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/logo.png', // Replace with your actual image path
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Please provide additional Information',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ).merge(Theme.of(context).elevatedButtonTheme.style),
                      child: Text(
                        'Finish',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
