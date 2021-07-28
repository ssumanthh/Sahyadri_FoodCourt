import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';
import 'foodcard.dart';
import 'package:sahyadri_food_court/widgets/loding.dart';

class Home_page extends StatefulWidget {
  Home_page({required this.auth});
  final BaseAuth auth;
  @override
  _Home_pageState createState() => _Home_pageState();
}

enum AuthStatus {
  home,
  fav,
}

AuthStatus authStatus = AuthStatus.home;
bool filter = false;
bool afilter = false;
bool search = false;
String filterType = '';
bool bpress = false;
bool mpress = false;
bool apress = false;
TextEditingController searchControler = TextEditingController();

class _Home_pageState extends State<Home_page> {
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
              added: false);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Let's create the welcoming Text
              Text(
                "Let's Enjoy the Food \n    Order your Food Now..",
                style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Color(0x55d2d2d2),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            search = true;
                            mpress = false;
                            bpress = false;
                            apress = false;
                          });
                        } else {
                          setState(() {
                            search = false;
                          });
                        }
                      },
                      controller: searchControler,
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
                      onPressed: () {
                        if(searchControler.text.isNotEmpty)
                        setState(() {
                          search = true;

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
              Row(
                children: [
                  Icon(Icons.filter_list_alt),

                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: bpress ? Color(0xFFfc6a26) : Colors.black,
                            width: 1),
                        hoverColor: Color(0xFFfc6a26),
                        focusColor: Color(0xFFfc6a26),
                        child: Text('Breakfast'),
                        onPressed: () {
                          setState(() {
                            bpress = !bpress;
                            filter = false;
                            mpress = false;
                            apress = false;
                          });
                          if (bpress) {
                            setState(() {
                              filterType = "breakfast";
                              filter = true;
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: mpress ? Color(0xFFfc6a26) : Colors.black,
                            width: 1),
                        child: Text('Meals'),
                        onPressed: () {
                          setState(() {
                            mpress = !mpress;
                            bpress = false;
                            apress = false;
                            filter = false;
                          });
                          if (mpress) {
                            setState(() {
                              filterType = "meals";
                              filter = true;
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: apress ? Color(0xFFfc6a26) : Colors.black,
                            width: 1),
                        child: Text('Available'),  
                        onPressed: () {
                          setState(() {
                            apress = !apress;
                            filter = false;
                            mpress = false;
                            bpress = false;
                          });
                          if (apress) {
                            setState(() {
                              filterType = "meals";
                              afilter = true;
                            });
                          }
                        }),
                  ),
                  // OutlineButton(child:Text('Veg'),onPressed: (){}),
                ],
              ),

              //build the food menu
              //I'm going to create a custom widget

              search
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("food")
                          .where(
                            'name',
                            isGreaterThanOrEqualTo: searchControler.text,
                          )
                          .where('name', isLessThan: searchControler.text + 'z')
                          .snapshots(),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        if (!snapshot.hasData) return LinearProgressIndicator();
                        if (snapshot.hasError)
                          return CircularProgressIndicator();
                        return Expanded(child: _buildGride(snapshot.data));
                      },
                    )
                  : filter
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("food")
                              .where(
                                'type',
                                isEqualTo: filterType,
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            print(snapshot.data);
                            if (!snapshot.hasData)
                              return Expanded(child: Loading());
                            if (snapshot.hasError)
                              return CircularProgressIndicator();
                            return Expanded(child: _buildGride(snapshot.data));
                          },
                        )
                      : afilter
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("food")
                                  .where(
                                    'available',
                                    isGreaterThan: 0,
                                  )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                print(snapshot.data);
                                if (!snapshot.hasData)
                                  return Expanded(child: Loading());
                                if (snapshot.hasError)
                                  return CircularProgressIndicator();
                                return Expanded(
                                    child: _buildGride(snapshot.data));
                              },
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("food")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                print(snapshot.data);
                                if (!snapshot.hasData)
                                  return Expanded(child: Loading());
                                if (snapshot.hasError)
                                  return CircularProgressIndicator();
                                return Expanded(
                                    child: _buildGride(snapshot.data));
                              },
                            )
            ],
          ),
        ));
  }

  Widget Button(String filtersType) {
    return FlatButton(
        onPressed: () {
          setState(() {
            print(filtersType);
            filterType = filtersType;
            filter = true;
          });
        },
        child: Text(filtersType));
  }
}
