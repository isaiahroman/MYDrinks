import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/alcoholicpage.dart';
import '/screens/profilepage.dart';
import '/screens/nonalcoholicpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, drinkTypeIndex});

  static int drinkTypeIndex = 1;

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final _titleTypes = ["Non-Alcoholic Drinks", "Alcoholic Drinks", "Profile"];
  String _title = "Alcoholic Drinks";
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _directionsController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  BorderRadius roundBorder = const BorderRadius.all(
    Radius.circular(20),
  );

  final PageController _pageController =
      PageController(initialPage: HomePage.drinkTypeIndex);

  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.local_drink_outlined),
      label: 'Non-Alcoholic',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.local_drink),
      label: 'Alcoholic',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Profile',
    ),
  ];

  Future<void> _addRecipie(int currentIndex) {
    String drinkType = "";
    if (currentIndex == 1) {
      drinkType = "Alcoholic";
    } else if (currentIndex == 0) {
      drinkType = "Non-Alcoholic";
    }

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.only(left: 25, right: 25),
            backgroundColor: Colors.purple[50],
            title: Text(
              "Add a $drinkType Drink",
              textAlign: TextAlign.center,
            ),
            content: Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildAddDrink(),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              // cancel button
              OutlinedButton(
                onPressed: () {
                  _updateText();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              // add drink Button
              OutlinedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    _addDrink(drinkType);
                    _updateText();
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple),
                ),
                child: const Text(
                  "Add Drink",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  void _updateText() {
    // setSet makes the page refresh
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _ingredientsController.clear();
      _directionsController.clear();
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) => HomePage(
              drinkTypeIndex: HomePage.drinkTypeIndex,
            )),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future _addDrink(String drinkType) async {
    await FirebaseFirestore.instance.collection(drinkType).add({
      "name": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "ingredients": _ingredientsController.text.trim(),
      "directions": _directionsController.text.trim(),
      "creator": user.email!
    });
  }

  Widget _buildAddDrink() => Form(
        key: _key,
        child: Column(
          children: [
            const SizedBox(height: 8),
            // name textformfield
            SizedBox(
              width: 325,
              child: TextFormField(
                controller: _nameController,
                minLines: 1,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: roundBorder),
                  hintText: 'Name',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: validatetextBoxNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            // description textformfield
            SizedBox(
              width: 325,
              child: TextFormField(
                controller: _descriptionController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: roundBorder),
                  hintText: 'Description',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: validatetextBoxNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            // ingredients textformfield
            SizedBox(
              width: 325,
              child: TextFormField(
                controller: _ingredientsController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: roundBorder),
                  hintText: 'Ingredients',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: validatetextBoxNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            // directions textformfield
            SizedBox(
              width: 325,
              child: TextFormField(
                controller: _directionsController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: roundBorder),
                  hintText: 'Directions',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: validatetextBoxNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: AppBar(
              title: Text(
                _title,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.purple[50]!.withOpacity(0.3),
              bottomOpacity: 0,
              elevation: 0,
              shadowColor: Colors.purple[50],
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            HomePage.drinkTypeIndex = newIndex;
            _title = _titleTypes[newIndex];
          });
        },
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          NonAlcoholicPage(),
          AlcoholicPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: HomePage.drinkTypeIndex,
        items: _bottomNavigationBarItems,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple[50],
        onTap: (newIndex) {
          _pageController.animateToPage(newIndex,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
      // add new recipie button
      floatingActionButton:
          (HomePage.drinkTypeIndex == 0 || HomePage.drinkTypeIndex == 1)
              ? FloatingActionButton(
                  onPressed: () => _addRecipie(HomePage.drinkTypeIndex),
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}

String? validatetextBoxNotEmpty(String? textBoxInfo) {
  if (textBoxInfo == null || textBoxInfo.isEmpty) {
    return "Field is required";
  }
  return null;
}
