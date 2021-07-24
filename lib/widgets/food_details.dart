import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/orders.dart';

import '../FoodApp.dart';

class Food_Details extends StatefulWidget {
  Food_Details(
      {required this.auth,
      required this.img,
      required this.name,
      required this.price,
      required this.available,
      required this.added});
  final BaseAuth auth;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Food Court'),
        ),
        backgroundColor: Colors.white,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                widget.img,
                width: 650,
                height: 400.0,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w600,
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
                              price = price + widget.price * count;
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
                                 price = price +widget. price * count;
                              }
                            });
                          },
                          icon: Icon(Icons.remove)),
                           Text(
                        '$price',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
              FlatButton(
                child: Text('Orders'),
                onPressed: () async {
                  await widget.auth.getfid().then((value) async {
                   widget.auth
                        .userOrder(fid, widget.name, count,price)
                        .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Orders(auth: widget.auth, fid: fid.toString())
                              ),
                            ));
                  });

                  if (fid != null && fid != '') {
                    widget.auth
                        .userOrder(fid, widget.name, count,price)
                        .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Orders(
                                  auth: widget.auth,
                                  fid: fid.toString(),
                                ),
                              ),
                            ));
                  }
                },
              )
            ]));
  }
}
