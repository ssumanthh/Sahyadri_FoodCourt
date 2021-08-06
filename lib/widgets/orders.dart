import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'loding.dart';

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

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              ? Loading()
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
                          elevation: 4,
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
                                       Row(
                                        children: [
                                          Text(
                                            "Status : ",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                         Text(
                                                 orderdetails[index]['status'],
                                                  style: TextStyle(
                                                    color: orderdetails[index]['status'] ==
                                                            'accepted'
                                                        ? Colors.green
                                                        : Colors.orange,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                        ],
                                      
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
    );
  }
}
