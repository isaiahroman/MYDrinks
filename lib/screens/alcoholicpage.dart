import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../read_data/get_default_drinks.dart';

class AlcoholicPage extends StatefulWidget {
  const AlcoholicPage({super.key});

  @override
  State<AlcoholicPage> createState() => _AlcoholicState();
}

class _AlcoholicState extends State<AlcoholicPage> {
  // document IDs
  List<String> docIDs = [];

  // get docIDs
  Future getDocIDs() async {
    await FirebaseFirestore.instance
        .collection("Alcoholic")
        .where("creator", isEqualTo: "default")
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach((documnet) {
            docIDs.add(documnet.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            title: GetDrinkInfo(
                              documentID: docIDs[index],
                              drinkType: "Alcoholic",
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
