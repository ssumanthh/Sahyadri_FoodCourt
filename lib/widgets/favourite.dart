import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';
import 'package:sahyadri_food_court/widgets/loading_anim.dart';

import 'foodcard.dart';

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
      Future.delayed(const Duration(seconds: 2), () {
         setState(() {
        favItems = value!;
        loading = false;
      });
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

          return Foodcard(auth:widget.auth,fd: doc.id, img:doc['image'], name:doc['name'], price:doc['cost'],available:doc['available'], added: true,);
        });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: loading?LoadingAnimPage(): favItems.isEmpty?Center(child:Text('No Favourites Added',
             style: TextStyle(
               color: Color(0xFFfc6a26),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),)): StreamBuilder<QuerySnapshot>(
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
