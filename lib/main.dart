import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './pages/splash_page.dart';

void main() async {
  // Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize hive
  await Hive.initFlutter();
  await Hive.openBox('favoriteBox');
  await Hive.openBox('favoriteDrinkNameBox');

  runApp(const MyApp());
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.purple[50],
          fontFamily: "Montserrat"),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
