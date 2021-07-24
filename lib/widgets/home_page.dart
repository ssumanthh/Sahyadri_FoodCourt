import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';
import 'foodcard.dart';

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
  String filterType = '';
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
              img: doc['image'],
              name: doc['name'],
              price: doc['cost'],
              available: doc['available'],
              added: false);
        });
  }

  @override
 Widget build (BuildContext context){
   return Scaffold(
     backgroundColor : Colors.white ,
     body: filter
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
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    if (snapshot.hasError) return CircularProgressIndicator();
                    return _buildGride(snapshot.data);
                  },
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
                              onPressed: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
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
                      Padding(
                        padding: EdgeInsets.only(left: 290),
                        child: PopupMenuButton(
                          child: Icon(Icons.filter_list_alt),
                          itemBuilder: (BuildContext context) {
                            return {'breakfast', 'meals'}.map((String choice) {
                              return PopupMenuItem<String>(
                                  value: choice, child: Button(choice));
                            }).toList();
                          },
                        ),
                      ),

                      //build the food menu
                      //I'm going to create a custom widget

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("food")
                            .snapshots(),
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          if (!snapshot.hasData)
                            return LinearProgressIndicator();
                          if (snapshot.hasError)
                            return CircularProgressIndicator();
                          return Expanded(child: _buildGride(snapshot.data));
                        },
                      )
                    ],
                  ),
                )
     );

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