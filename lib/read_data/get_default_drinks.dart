import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import '/pages/homepage.dart';

class GetDrinkInfo extends StatefulWidget {
  const GetDrinkInfo(
      {super.key, required this.documentID, required this.drinkType});

  final String documentID;
  final String drinkType;

  @override
  State<GetDrinkInfo> createState() => _GetDrinkInfoState();
}

class _GetDrinkInfoState extends State<GetDrinkInfo> {
  // refernce our databases for saved drinks
  final _box = Hive.box('favoriteBox');
  final _drinkNameBox = Hive.box('favoriteDrinkNameBox');

  // write data to box
  void _writeData(int key, String name, String description, String ingredients,
      String directions) {
    _box.put(key, name);
    _box.put(key + 1, description);
    _box.put(key + 2, ingredients);
    _box.put(key + 3, directions);
  }

  // reads data from box
  dynamic _readData(int keyValue) {
    return _box.get(keyValue);
  }

  void _saveDrink(
      String name, String description, String ingredients, String directions) {
    bool alreadySaved = false;
    int key = 0;

    for (int i = 0; i < 5; i++) {
      if (_drinkNameBox.get(i) == name) {
        alreadySaved = true;
      }
      if (alreadySaved == false &&
          _readData(i) == null &&
          _readData(i + 1) == null &&
          _readData(i + 2) == null &&
          _readData(i + 3) == null) {
        key = i;
        _writeData(key, name, description, ingredients, directions);
        _drinkNameBox.put(key, name);
        break;
      }
    }

    if (alreadySaved == true) {
      for (int i = 0; i < 5; i++) {
        if (_readData(i) == name) {
          _box.delete(i);
          _box.delete(i + 1);
          _box.delete(i + 2);
          _box.delete(i + 3);
          _drinkNameBox.delete(i);
        }
      }
    }
  }

  BorderRadius roundBorder = const BorderRadius.all(
    Radius.circular(20),
  );

  bool _checkIfDrinkSaved(String name) {
    for (int i = 0; i < 100; i++) {
      if (_readData(i) == name) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  final user = FirebaseAuth.instance.currentUser!;

  Widget _createDrinkTile(String name, String description, String ingredients,
      String directions, String creator, String drinkType, String documentID) {
    bool alreadySaved = _checkIfDrinkSaved(name);
    int drinkTypeIndex = 1;
    if (widget.drinkType == 'Alcoholic') {
      drinkTypeIndex = 1;
    } else if (widget.drinkType == ' Non-Alcoholic') {
      drinkTypeIndex = 0;
    }
    return Column(
      children: <Widget>[
        // name text and heart icon
        Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: <Widget>[
              Align(
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                right: -14,
                top: -13,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: alreadySaved ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {});
                    _saveDrink(name, description, ingredients, directions);
                  },
                ),
              ),
              (creator == user.email!)
                  ? Positioned(
                      top: -13,
                      right: 299,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(drinkType)
                              .doc(documentID)
                              .delete();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  ((context, animation, secondaryAnimation) =>
                                      HomePage(drinkTypeIndex: drinkTypeIndex)),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ))
                  : const Text(' ')
            ],
          ),
        ),
        // description text
        Text(
          description,
          style: const TextStyle(fontSize: 12),
        ),
        // you will need text
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "You will need:",
            style:
                TextStyle(fontSize: 16, decoration: TextDecoration.underline),
          ),
        ),
        // ingredients texts
        Text(
          ingredients,
          style: const TextStyle(fontSize: 16),
        ),
        // directions text
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Directions:",
            style:
                TextStyle(fontSize: 16, decoration: TextDecoration.underline),
          ),
        ),
        // directions text
        Text(
          directions,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference drinks =
        FirebaseFirestore.instance.collection(widget.drinkType);

    return FutureBuilder<DocumentSnapshot>(
      future: drinks.doc(widget.documentID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListTile(
            title: _createDrinkTile(
                data["name"],
                data["description"],
                data["ingredients"],
                data["directions"],
                data["creator"],
                widget.drinkType,
                widget.documentID),
            tileColor: Colors.purple[100],
            shape: RoundedRectangleBorder(borderRadius: roundBorder),
          );
        }
        return const Text("Loading . . .");
      },
    );
  }
}
