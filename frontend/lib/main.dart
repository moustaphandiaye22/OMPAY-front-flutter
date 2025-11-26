import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/services/auth_provider.dart';
import 'package:frontend/services/payment_provider.dart';
import 'package:frontend/services/transfer_provider.dart';
import 'package:frontend/services/theme_provider.dart';
import 'package:frontend/services/language_provider.dart';
import 'package:frontend/utils/service_locator.dart';

void main() {
  final serviceLocator = ServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: serviceLocator),
        ChangeNotifierProvider(create: (_) => AuthProvider(serviceLocator.authService)),
        ChangeNotifierProvider(create: (_) => serviceLocator.paymentProvider),
        ChangeNotifierProvider(create: (_) => serviceLocator.transferProvider),
        ChangeNotifierProvider(create: (_) => serviceLocator.themeProvider),
        ChangeNotifierProvider(create: (_) => serviceLocator.languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'OM Pay',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Afficher la page d'accueil si connecté, sinon la page de connexion
    return authProvider.isLoggedIn
        ? const HomePage()
        : const OrangeMoneyLoginPage();
  }
}
