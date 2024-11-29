import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/animation_theme.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouters();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(0xFF006400, {
              50: Color(0xFFE8F5E9),
              100: Color(0xFFC8E6C9),
              200: Color(0xFFA5D6A7),
              300: Color(0xFF81C784),
              400: Color(0xFF66BB6A),
              500: Color(0xFF4CAF50),
              600: Color(0xFF43A047),
              700: Color(0xFF388E3C),
              800: Color(0xFF2E7D32),
              900: Color(0xFF1B5E20),
            }),
            accentColor: const Color(0xFF8BC34A),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            bodyLarge: TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            titleMedium: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
            labelLarge: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF8BC34A),
            textTheme: ButtonTextTheme.primary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Color(0xFF388E3C), width: 2.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
              elevation: 4.0,
              shadowColor: Colors.black.withOpacity(0.25),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 2.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            hintStyle: TextStyle(color: Colors.black54),
            prefixIconColor: Colors.black54,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
          // Add animation duration and scale factors in the theme
          // extensions: const <ThemeExtension>[
          //   AnimationTheme(
          //     hoverScale: 1.0,
          //     pressScale: 0.95,
          //     duration: Duration(milliseconds: 150),
          //   ),
          // ],

          useMaterial3: true,
          extensions: const <ThemeExtension<dynamic>>[
            AnimationTheme(
                hoverScale: 1.1,
                pressScale: 0.9,
                duration: Duration(milliseconds: 200))
          ]),
      routerConfig: _appRouter.config(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
