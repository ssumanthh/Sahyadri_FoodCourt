import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';
import 'package:sahyadri_food_court/widgets/order_done_anim.dart';

import 'foodcard.dart';

class Orders extends StatefulWidget {
  Orders({required this.auth, required this.fid});
  final BaseAuth auth;
  final String fid;
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<dynamic> orderdetails = [];
  String fid = '';
  bool loading = true;
  void getid() async {
    await widget.auth.getfid().then((value) async {
      setState(() {
        fid = value.toString();
      });
      widget.auth.getorder(fid).then((value) {
        print(value);
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            orderdetails = value!;
            loading = false;
          });
        });

        print('hone$orderdetails');
      });
    });
  }

  void initState() {
    super.initState();
    getid();
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
            fd: doc.id,
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[50],
          onPressed: () {
            setState(() {
              loading = true;
            });
            getid();
          },
          child: Icon(
            Icons.refresh,
            color: Color(0xFFfc6a26),
          ),
        ),
        body: loading
            ? Loader()
            : orderdetails.isEmpty
                ? Center(
                    child: Text(
                    'No Orders yet',
                    style: TextStyle(
                      color: Color(0xFFfc6a26),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
                : ListView.builder(
                    itemCount: orderdetails.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              orderdetails[index]['name'],
                              style: TextStyle(fontSize: 21),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Number of Items'),
                                      Text(orderdetails[index]['itemCount']
                                          .toString()),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Price'),
                                      Text(
                                          "${orderdetails[index]['price'].toString()} ₹"),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ));
  }
}
