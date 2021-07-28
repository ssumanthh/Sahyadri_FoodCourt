import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loding.dart';
import 'package:sahyadri_food_court/widgets/primary_button.dart';

import 'order_done_anim.dart';

class Food_Details extends StatefulWidget {
  Food_Details(
      {required this.auth,
      required this.img,
      required this.foodId,
      required this.name,
      required this.price,
      required this.available,
      required this.added});
  final BaseAuth auth;
  final String foodId;
  final String img;
  final String name;
  final int price;
  final int available;
  final bool added;
  @override
  _Food_DetailsState createState() => _Food_DetailsState();
}

class _Food_DetailsState extends State<Food_Details> {
  int count = 0;
  String? fid = '';
  int price = 0;
  bool done = false;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFfcfcfc),
          title: Text(
            "Food Details",
            style: TextStyle(
              color: Color(0xFFfc6a26),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: done
            ? OrderDoneAnimPage()
            : load
                ? Loading()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Image.network(widget.img, width: 650, height: 320.0,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          return Container(
                            width: 650,
                            height: 320,
                            child: const Opacity(
                                opacity: 0.8, child: Icon(Icons.image)),
                          );
                        }, loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            width: 650,
                            height: 320,
                            child:
                                Opacity(opacity: 0.4, child: Icon(Icons.image)),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                                  'Available:',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.available.toString(),
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
                                  'Item Count:',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        count = count + 1;
                                        price = widget.price * count;
                                      });
                                    },
                                    icon: Icon(Icons.add)),
                                Text(
                                  '$count',
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (count > 0) {
                                          count = count - 1;
                                          price = widget.price * count;
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.remove)),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price:',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  price.toString(),
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                        ),
                        PrimaryButton(
                          key: Key("order"),
                          text: 'Order Now!!',
                          height: 40,
                          onPressed: () async {
                            if (widget.available <= 0) {
                              final snackBar = SnackBar(
                                  backgroundColor: Color(0xFFf68634),
                                  padding: EdgeInsets.all(22),
                                  content: Text('Food Not Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (count <= 0) {
                                final snackBar = SnackBar(
                                  backgroundColor: Color(0xFFf68634),
                                  padding: EdgeInsets.all(22),
                                  content: Text('Add item count to Order:)',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              } 
                              else {
                                setState(() {
                                  load = true;
                                });
                                Future.delayed(const Duration(seconds: 10), () {
                                  final snackBar = SnackBar(
                                      backgroundColor: Color(0xFFf68634),
                                      padding: EdgeInsets.all(22),
                                      content: Text(
                                          ' Check your Internet Connection',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                                await widget.auth.getfid().then((value) async {
                                  setState(() {
                                    fid = value;
                                  });
                                });

                                if (fid != null && fid != '') {
                                  widget.auth
                                      .userOrder(fid, widget.name, count, price)
                                      .then((value) {
                                    int available = widget.available - count;
                                    FirebaseFirestore.instance
                                        .collection('food')
                                        .doc(widget.foodId)
                                        .set({
                                      'available': available
                                    }, SetOptions(merge: true)).then((value) {
                                      setState(() {
                                        done = true;
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.pop(context);
                                      });
                                    });
                                  }).catchError((error) {
                                    final snackBar = SnackBar(
                                        content:
                                            Text(' Order UnSuccessfull!!!'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  });
                                }
                              }
                            }
                          },
                        )
                      ]));
  }
}
