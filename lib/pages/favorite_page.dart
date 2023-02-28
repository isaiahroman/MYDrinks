import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoritePage> {
  // refernce our databases for saved drinks
  final _box = Hive.box('favoriteBox');

  // reads data from box, and if there is no data will give a value of '0'
  dynamic _readData(int keyValue) {
    return _box.get(keyValue);
  }

  @override
  Widget build(BuildContext context) {
    List<String> savedDrink = [];
    for (int i = 0; i < 5; i++) {
      if (_readData(i) != null) {
        savedDrink.add(_readData(i));
      } else {
        savedDrink.add("Nothing Added");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Favorite Drink",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
        shadowColor: Colors.purple[50],
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Center(
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: <Widget>[
                      // name text and heart icon
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            savedDrink[0],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // description text
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          savedDrink[1],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      // you will need text
                      const Padding(
                        padding: EdgeInsets.only(top: 10, right: 214.7),
                        child: Text(
                          "You will need:",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      // ingredients texts
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          savedDrink[2],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      // directions text
                      const Padding(
                        padding: EdgeInsets.only(top: 8, right: 236.7),
                        child: Text(
                          "Directions:",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      // directions text
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          savedDrink[3],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
