import 'package:flutter/material.dart';
import 'package:savor/common/styles.dart';
import 'package:savor/config/routes.dart';
import 'package:savor/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savor',
      theme: ThemeData(
        textTheme: textTheme,
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
