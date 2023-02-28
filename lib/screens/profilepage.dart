import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/pages/a_userdrinks_page.dart';
import '/pages/allalcoholicdrinks_page.dart';
import '/pages/na_userdrinks_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  //
  final user = FirebaseAuth.instance.currentUser!;

  BorderRadius roundBorder = const BorderRadius.all(
    Radius.circular(15),
  );

  Widget _showLoggedInUser() {
    return Center(
      child: Container(
        height: 90,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: Colors.purple[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You are logged in as:",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              user.email!,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  Widget _alcoholicDrinksButton() {
    return Center(
      child: SizedBox(
        height: 90,
        width: 350,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const UserAlcDrinks()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              backgroundColor: Colors.purple[100],
              elevation: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "View My Alcoholic",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Drinks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _nonAlcoholicDrinksButton() {
    return Center(
      child: SizedBox(
        height: 90,
        width: 350,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const UserNonAlcDrinks()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              backgroundColor: Colors.purple[100],
              elevation: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "View My Non-Alcoholic",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Drinks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _allAlcoholicDrinksButton() {
    return Center(
      child: SizedBox(
        height: 90,
        width: 350,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const AllUserAlcDrinks()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              backgroundColor: Colors.purple[100],
              elevation: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "View Other Users",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Alcoholic Drinks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signOutButton() {
    return Center(
      child: SizedBox(
        height: 90,
        width: 350,
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              backgroundColor: Colors.purple[100],
              elevation: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 110),
              Text(
                "Sign Out",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(width: 71.8),
              Icon(
                Icons.logout,
                color: Colors.black,
                size: 35,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _showLoggedInUser(),
          const SizedBox(height: 25),
          _alcoholicDrinksButton(),
          const SizedBox(height: 25),
          _nonAlcoholicDrinksButton(),
          const SizedBox(height: 25),
          _allAlcoholicDrinksButton(),
          const SizedBox(height: 25),
          _signOutButton()
        ]),
      ),
    );
  }
}
