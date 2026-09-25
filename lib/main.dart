import 'package:flutter/material.dart';
import 'core/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/cart_controller.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final CartController cart = CartController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.storeName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(cart: cart),
    );
  }
}