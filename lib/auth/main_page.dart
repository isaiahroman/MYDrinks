import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './auth_page.dart';
import '../pages/homepage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  // Checks to see if a user is logged in.  If they are logged in, we are
  // returning the homepage, else we are returning the auth page (which is
  // the login/signup page)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const AuthPage();
        }
      },
    ));
  }
}
