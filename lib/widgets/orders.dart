import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';

import '../foodcard.dart';

class Orders extends StatefulWidget {
  Orders({required this.auth});
  final BaseAuth auth;
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<dynamic> orders = [];
  List<String> ordernames = [];
  bool loading = true;
  void initState() {
    super.initState();
    widget.auth.getorder().then((value) {
      setState(() {
       orders = value!;
        loading = false;
        orders.forEach((element) {
         ordernames.add(element['name']);
        });
      });
      print('hone$ordernames');
    });
  }

  Widget _buildGride(QuerySnapshot? snapshot) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          return Foodcard(auth:widget.auth, img:doc['image'], name:doc['name'], price:doc['cost'],available:doc['available'], added: true,);
        });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: loading?Loader(): ordernames.isEmpty?Center(child:Text('no data')): StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("food")
                        .where(
                          'name',
                          whereIn:ordernames,
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
