import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';

import 'foodcard.dart';

class Orders extends StatefulWidget {
  Orders({required this.auth, required this.fid});
  final BaseAuth auth;
  final String fid;
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<dynamic> orders = [];
  List<Map<String,dynamic>> orderdetails = [];
  bool loading = true;
  void initState() {
    super.initState();
    widget.auth.getorder(widget.fid).then((value) {
      print(value);
      setState(() {
        orders = value!;
        loading = false;

        orders.forEach((element) {
          orderdetails.add(element);
        });
      });
      print('hone$orderdetails');
    });
  }

  Widget _buildGride(QuerySnapshot? snapshot) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          return Foodcard(
            auth: widget.auth,
            img: doc['image'],
            name: doc['name'],
            price: doc['cost'],
            available: doc['available'],
            added: true,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? Loader()
          : orderdetails.isEmpty
              ? Center(child: Text('no data'))
              :ListView.builder(
  itemCount: orders.length,
  itemBuilder: (context, index) {
    return Card(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
        title: Text(orderdetails[index]['name'],
        style: TextStyle(
          fontSize: 21
        ),),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Items'),
                 Text(orderdetails[index]['itemCount'].toString()),
            ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price'),
                 Text("${orderdetails[index]['price'].toString()} ₹"),
            ]
            ),
          ],
        ),
    ),)
      );
  },
)
    );
  }
}
