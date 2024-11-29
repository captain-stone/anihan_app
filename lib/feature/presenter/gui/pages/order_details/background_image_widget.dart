import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Top gradient fill
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: screenHeight * 0.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE8F5E9),
                    Color(0xFF81C784),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        // Expanded center image
        Positioned.fill(
          top: screenHeight * 0.1,
          bottom: screenHeight * 0.1,
          child: Image.asset(
            'assets/asdf.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        // Bottom gradient fill
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF81C784),
                    Color(0xFFE8F5E9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
