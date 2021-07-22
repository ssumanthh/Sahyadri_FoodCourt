import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';

import '../foodcard.dart';

class favourite extends StatefulWidget {
  favourite({required this.auth});
  final BaseAuth auth;
  @override
  _favouriteState createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {
  List<dynamic> favItems = [];
  bool loading = true;
  void initState() {
    super.initState();
    widget.auth.getfavFood().then((value) {
      setState(() {
        favItems = value!;
        loading = false;
      });
      print('hone$favItems');
    });
  }

  Widget _buildGride(QuerySnapshot? snapshot) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          return foodCard(widget.auth, doc['image'], doc['name'], doc['cost'],true);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: loading?Loader(): StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("food")
                        .where(
                          'name',
                          whereIn: favItems,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      if (snapshot.hasError) return CircularProgressIndicator();
                      return _buildGride(snapshot.data);
                    },
                  ),);
  }
}
