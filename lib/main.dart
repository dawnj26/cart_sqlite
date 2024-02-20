import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinto_assignment2/models/cart.dart';
import 'package:quinto_assignment2/models/product.dart';

// Screens
import 'package:quinto_assignment2/screens/home_screen.dart';

// Components

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => CartList()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
