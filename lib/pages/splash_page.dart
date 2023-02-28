import 'package:flutter/material.dart';
import '../auth/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigatetologin();
  }

  _navigatetologin() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.purple,
            image: const DecorationImage(
              image: AssetImage('images/logo.png'),
            ),
            border: Border.all(
                color: Colors.purple, width: 5, style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.purple, blurRadius: 60.0, spreadRadius: 25.0)
            ],
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
