import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = "";

  BorderRadius roundBorder = const BorderRadius.all(
    Radius.circular(20),
  );

  Widget _logIn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // email
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: roundBorder),
              hintText: 'Enter Email',
              filled: true,
              fillColor: Colors.grey[100],
            ),
            style: const TextStyle(fontSize: 19),
            validator: validateEmail,
          ),
        ),
        const SizedBox(height: 12),
        // password
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: roundBorder),
              hintText: 'Enter Password',
              filled: true,
              fillColor: Colors.grey[100],
            ),
            style: const TextStyle(fontSize: 19),
            validator: validatePassword,
          ),
        ),
        const SizedBox(height: 7.5),
        // display any error messages
        Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
        ),
        const SizedBox(height: 7.5),
        // log in button
        SizedBox(
          width: 350,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: roundBorder)),
            onPressed: () {
              if (_key.currentState!.validate()) {
                _logUserIn();
              }
            },
            child: const Text("Log In", style: TextStyle(fontSize: 19)),
          ),
        )
      ],
    );
  }

  Future _logUserIn() async {
    // authenticating the user and handling errors
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      errorMessage = "";
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = error.message!;
      });
    }
  }

  Widget _signUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Don't have an account?  ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: widget.showRegisterPage,
          child: Text("Sign up",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const SizedBox(
                    width: 300,
                    child: Image(image: AssetImage('images/logo.png'))),
                _logIn(context),
                const SizedBox(height: 10),
                _signUp(context),
                const SizedBox(height: 95),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Email is required";
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(email)) {
    return "Invalid email format";
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return "Password is required";
  }

  if (password.length < 6) {
    return "Password must be at least 6 characters";
  }
  return null;
}
