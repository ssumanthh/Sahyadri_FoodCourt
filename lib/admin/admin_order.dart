import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';

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
  TextEditingController getOrderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Let's create the welcoming Text
            Text(
              "Hello Admin \n ",
              style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Color(0x55d2d2d2),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search... ",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20.0),
                    ),
                  )),
                  RaisedButton(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed:() {
                          widget.auth.getorder(getOrderController.text).then((value) {
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
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                        color: Color(0xFFfc6a26),
                      ),
                    ],
                  ),
                ),
               loading?Center(
          child:Text("Enter the Order id to check",
          style: TextStyle(fontSize: 20),
          ),
          ): orderdetails.isEmpty
                        ? Center(child: Text('no data'))
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Card(
                                  
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
                                )),
                              );
                            },
                          )
              ]),
        ),
      );
  }
}
