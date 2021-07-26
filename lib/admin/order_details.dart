import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/primary_button.dart';

class Order_Details extends StatefulWidget {
  Order_Details({
    required this.auth,
    required this.fid,
    required this.name,
    required this.price,
    required this.itemCount,
  });
  final String fid;
  final BaseAuth auth;
  final String name;
  final int price;
  final int itemCount;
  @override
  _Order_DetailsState createState() => _Order_DetailsState();
}

class _Order_DetailsState extends State<Order_Details> {
  int count = 0;
  String? fid = '';
  int price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 180, 8.0, 50),
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.black)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Faculty ID:',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.fid.toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Food Name:',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.name.toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.price.toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of items:',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.itemCount.toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            PrimaryButton(
                key: new Key('order'),
                text: 'Confirm Order',
                height: 40,
                onPressed: () {
                  print(widget.fid);
                  FirebaseFirestore.instance
                      .collection('orders')
                      .doc(widget.fid) // <-- Document ID
                      .set(
                          {
                        'orders': FieldValue.arrayRemove([
                          {
                            'name': widget.name,
                            'itemCount': widget.itemCount,
                            'price': widget.price
                          }
                        ])
                      },
                          SetOptions(
                            merge: true,
                          )) // <-- Add data
                      .then((_) {
                    print("done");
                    final snackBar = SnackBar(backgroundColor: Color(0xFFf68634),  content: Text('Confirmed Order Successfull!!',style: TextStyle(color: Colors.white,),));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                    
                  });
                }),
          ],
        ));
  }
}
