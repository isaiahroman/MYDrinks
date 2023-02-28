import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/read_data/get_all_a_user_drinks.dart';

class AllUserAlcDrinks extends StatefulWidget {
  const AllUserAlcDrinks({super.key});

  @override
  State<AllUserAlcDrinks> createState() => _AllUserAlcDrinksState();
}

class _AllUserAlcDrinksState extends State<AllUserAlcDrinks> {
  final user = FirebaseAuth.instance.currentUser!;

  // document IDs
  List<String> docIDs = [];

  // get docIDs
  Future getDocIDs() async {
    await FirebaseFirestore.instance.collection("Alcoholic").get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach((documnet) {
            docIDs.add(documnet.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    // document IDs
    List<String> docIDs = [];

    // get docIDs
    Future getDocIDs() async {
      await FirebaseFirestore.instance
          .collection("Alcoholic")
          .where("creator", whereNotIn: ["default", user.email!])
          .get()
          .then(
            // ignore: avoid_function_literals_in_foreach_calls
            (snapshot) => snapshot.docs.forEach((documnet) {
              docIDs.add(documnet.reference.id);
            }),
          );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: AppBar(
              title: const Text(
                'Other User\'s Alcoholic Drinks',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getDocIDs(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: GetAllUserAlcDrinks(
                              documentID: docIDs[index],
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
