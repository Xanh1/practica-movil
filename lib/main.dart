import 'package:flutter/material.dart';
import 'package:prueba_1/screens/branch_screen.dart';
import 'package:prueba_1/screens/login_screen.dart';
import 'package:prueba_1/screens/map_screen.dart';
import 'package:prueba_1/screens/product_screen.dart';
import 'package:prueba_1/screens/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Censo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),    
      home: const LoginScreen(),
      initialRoute: "session",
      routes: {
        '/dashboard/products': (context) => const ProductScreen(),
        '/dashboard/user': (context) => const UserScreen(),
        '/dashboard/map': (context) => const MapScreen(),
        '/dashboard/branch': (context) => const Branchcreen()
      },
    );
  }
}
