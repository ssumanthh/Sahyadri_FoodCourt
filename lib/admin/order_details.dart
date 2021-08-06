import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';

class Order_Details extends StatefulWidget {
  Order_Details({
    required this.auth,
    required this.orders,
    required this.id,
  });
  final List orders;
  final BaseAuth auth;
  final String id;

  @override
  _Order_DetailsState createState() => _Order_DetailsState();
}

class _Order_DetailsState extends State<Order_Details> {
  int count = 0;
  String? fid = '';

  bool loading = false;

  List accept = [];
  void initState() {
    super.initState();
    for (var i = 0; i < widget.orders.length; i++) {
      accept.add(false);
    }
    getname(widget.id);
  }

  Future<void> getname(String id) async {
    await FirebaseFirestore.instance
        .collection('name')
        .where("facultyid", isEqualTo: id)
        .get()
        .then((value) {
      print(value.docs[0].get("username"));

      setState(() {
        fid = value.docs[0].get("username");
      });
    });
  }

  void done() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        backgroundColor: Colors.white,
        body: loading
            ? Loader()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            widget.id,
                            style: TextStyle(fontSize: 22),
                          ),
                          
                          AutoSizeText(
                            fid.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.orders.length,
                        itemBuilder: (context, index) {
                          final doc = widget.orders[index];

                          print(doc);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shadowColor: Colors.black,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      isThreeLine: true,
                                      title: Text(
                                        "Order Name :${doc['name']}",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Order Count : ${doc['itemCount']}\nCost : ${doc['price']} ₹\n",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Status : ",
                                            style: TextStyle(
                                              fontSize: 19,
                                            ),
                                          ),
                                          accept[index]
                                              ? Text(
                                                  "accepted",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 19,
                                                  ),
                                                )
                                              : Text(
                                                  doc['status'],
                                                  style: TextStyle(
                                                    color: doc['status'] ==
                                                            'accepted'
                                                        ? Colors.green
                                                        : Colors.orange,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //button to make calls
                                        SizedBox(
                                          width: 100,
                                        ),
                                        //button to send msg
                                        doc['status'] == 'accepted' ||
                                                accept[index]
                                            ? SizedBox(width: 0)
                                            : new RaisedButton(
                                                child: new Text('Acccept Order',
                                                    style: new TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0)),
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                color: Color(0xFFf68634),
                                                textColor: Colors.black87,
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(widget.id)
                                                      .update(
                                                    {
                                                      'orders': FieldValue
                                                          .arrayRemove([
                                                        {
                                                          'name': doc['name'],
                                                          'itemCount':
                                                              doc['itemCount'],
                                                          'price': doc['price'],
                                                          'status': 'waiting'
                                                        }
                                                      ])
                                                    },
                                                  ).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .doc(widget.id)
                                                        .update(
                                                      {
                                                        'orders': FieldValue
                                                            .arrayUnion([
                                                          {
                                                            'name': doc['name'],
                                                            'itemCount': doc[
                                                                'itemCount'],
                                                            'price':
                                                                doc['price'],
                                                            'status': 'accepted'
                                                          }
                                                        ])
                                                      },
                                                    ).then(
                                                      (value) {
                                                        print('done');
                                                        setState(() {
                                                          accept[index] = true;
                                                        });
                                                        done();
                                                      },
                                                    );
                                                  });
                                                }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  new RaisedButton(
                      padding: EdgeInsets.fromLTRB(110, 10, 110, 10),
                      child: new AutoSizeText('Confirm All Orders',
                          maxLines: 1,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 20.0)),
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      color: Color(0xFFf68634),
                      textColor: Colors.black87,
                      onPressed: () {
                        showAlertDialog(context);
                      }),
                ],
              ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text(
          "yes",
          style: TextStyle(
            color: Color(0xFFfc6a26),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            loading = true;
          });
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.id)
              .delete()
              .then((value) {
                 setState(() {
            loading = false;
          });
            Navigator.pop(context);
          });
        });
    Widget cancelButton = FlatButton(
      child: Text(
        "NO",
        style: TextStyle(
          color: Color(0xFFfc6a26),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Confirm All Orders ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
