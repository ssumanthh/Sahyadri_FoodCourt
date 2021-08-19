import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/admin/order_details.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';

class AdminOdrder extends StatefulWidget {
  AdminOdrder({required this.auth});
  final BaseAuth auth;
  @override
  _AdminOdrderState createState() => _AdminOdrderState();
}

class _AdminOdrderState extends State<AdminOdrder> {
  List<dynamic> orders = [];
  List<Map<String, dynamic>> orderdetails = [];
  bool loading = true;
  bool load = false;
  List name = [];

  TextEditingController getOrderController = TextEditingController();

  void readData() async {
    print(getOrderController.text);
    widget.auth.getorder(getOrderController.text).then((value) {
      print(value);
      setState(() {
        orders = value!;
        load = false;
        orderdetails = [];
        orders.forEach((element) {
          orderdetails.add(element);
        });
      });
      print(orderdetails);
    });
  }

  FutureOr onGoBack(dynamic value) {
    readData();
    setState(() {});
  }

  Future<String?> getname(String id) async {
    //get name of the faculty
    String? fid = '';
    await FirebaseFirestore.instance
        .collection('name')
        .where("facultyid", isEqualTo: id)
        .get()
        .then((value) {
      print(value.docs[0].get("username"));
      fid = value.docs[0].get("username");
      setState(() {
        name.add(fid);
      });
    });

    if (fid != '') {
      return fid;
    }
  }

  Widget _buildGride(QuerySnapshot? snapshot) {
    //display oders in the list formate
    return ListView.builder(
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          print(name);
          return doc.get('orders').toString() != '[]'
              ? GestureDetector(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            doc.id,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    List b = doc['orders'];
                    print(b);
                     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                    Order_Details(auth: widget.auth, orders:b, id: doc.id,),));
                  },
                )
              : SizedBox(
                  height: 0,
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
               
                SizedBox(
                  height: 20.0,
                ),
                
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("orders")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    if (snapshot.hasError) return CircularProgressIndicator();
                    return Expanded(child: _buildGride(snapshot.data));
                  },
                )
              ]),
        ),
      ),
    );
  }
}
