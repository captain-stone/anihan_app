import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/animation_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          extensions: <ThemeExtension<dynamic>>[
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
