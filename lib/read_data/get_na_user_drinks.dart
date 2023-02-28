// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class GetUserNonAlcDrinks extends StatefulWidget {
  const GetUserNonAlcDrinks({super.key, required this.documentID});

  final String documentID;

  @override
  State<GetUserNonAlcDrinks> createState() => _GetUserNonAlcDrinksState();
}

class _GetUserNonAlcDrinksState extends State<GetUserNonAlcDrinks> {
  BorderRadius roundBorder = const BorderRadius.all(
    Radius.circular(20),
  );

  final user = FirebaseAuth.instance.currentUser!;

  Widget _createDrinkTile(String name, String description, String ingredients,
      String directions, String creator, String documentID) {
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
              (creator == user.email!)
                  ? Positioned(
                      top: -13,
                      right: -14,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Non-Alcoholic")
                              .doc(documentID)
                              .delete();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  ((context, animation, secondaryAnimation) =>
                                      GetUserNonAlcDrinks(
                                        documentID: documentID,
                                      )),
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
        FirebaseFirestore.instance.collection("Non-Alcoholic");

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
