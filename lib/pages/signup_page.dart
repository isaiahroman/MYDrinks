import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({super.key, required this.showLoginPage});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = "";

  BorderRadius roundBorder = const BorderRadius.all(
    Radius.circular(20),
  );

  Widget _signUp(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // first name
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: roundBorder),
              hintText: 'First Name',
              filled: true,
              fillColor: Colors.grey[100],
            ),
            style: const TextStyle(fontSize: 19),
            validator: validateName,
          ),
        ),
        const SizedBox(height: 12),
        // last name
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: roundBorder),
              hintText: 'Last Name',
              filled: true,
              fillColor: Colors.grey[100],
            ),
            style: const TextStyle(fontSize: 19),
            validator: validateName,
          ),
        ),
        const SizedBox(height: 12),
        // email
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: roundBorder),
              hintText: 'Email',
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
              hintText: 'Password',
              filled: true,
              fillColor: Colors.grey[100],
            ),
            style: const TextStyle(fontSize: 19),
            validator: validatePassword,
          ),
        ),
        const SizedBox(height: 12),
        // confirm password
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _confirmpasswordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: roundBorder),
              hintText: 'Confirm Password',
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
          child: Text(errorMessage),
        ),
        const SizedBox(height: 7.5),
        // sign up button
        SizedBox(
          width: 350,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: roundBorder)),
            onPressed: () {
              if (_key.currentState!.validate()) {
                _signUserUp();
              }
            },
            child: const Text("Sign Up", style: TextStyle(fontSize: 19)),
          ),
        )
      ],
    );
  }

  Future _signUserUp() async {
    // creating the user and handling errors
    if (_passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // adding user details
        _addUserDetails(_firstNameController.text.trim(),
            _lastNameController.text.trim(), _emailController.text.trim());
        errorMessage = "";
      } on FirebaseAuthException catch (error) {
        setState(() {
          errorMessage = error.message!;
        });
      }
    }
  }

  Future _addUserDetails(
      String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection("users").add({
      "first name": firstName,
      "last name": lastName,
      "email": email,
    });
  }

  bool _passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      errorMessage = "";
      return true;
    } else {
      setState(() {
        errorMessage = "Passwords don't match...";
      });
      return false;
    }
  }

  Widget _logIn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Already have an account?  ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: widget.showLoginPage,
          child: Text("Log in",
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
                const SizedBox(
                    width: 300,
                    child: Image(image: AssetImage('images/logo.png'))),
                _signUp(context),
                const SizedBox(height: 23),
                _logIn(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validateName(String? email) {
  if (email == null || email.isEmpty) {
    return "Field is required";
  }
  return null;
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
