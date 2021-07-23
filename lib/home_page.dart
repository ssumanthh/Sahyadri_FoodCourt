

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';
import 'authentication/auth.dart';
import 'foodcard.dart';

class FoodApp extends StatefulWidget {
  FoodApp({required this.auth, required this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _FoodAppState createState() => _FoodAppState();
}

enum AuthStatus {
  home,
  fav,
}

AuthStatus authStatus = AuthStatus.home;

class _FoodAppState extends State<FoodApp> {
  CollectionReference username = FirebaseFirestore.instance.collection('food');
  //here i'm going to place a list of image url
  // List<String> imgUrl = [
  //   "https://pngimage.net/wp-content/uploads/2018/06/idli-png-1.png",
  //   "https://pngimage.net/wp-content/uploads/2019/05/dosa-png-images-hd-2.jpg",
  //   "https://pngimage.net/wp-content/uploads/2018/06/poori-png.png",
  //   "https://pngimage.net/wp-content/uploads/2018/06/parota-png-1.png",
  //   "https://pngimage.net/wp-content/uploads/2018/06/sizzler-png-2.png",
  //   "https://pngimage.net/wp-content/uploads/2018/06/sizzler-png-8.png",
  // ];
  int index = 0;
  bool filter = false;
  String filterType = '';

  Widget _buildGride(QuerySnapshot? snapshot) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          return Foodcard(auth:widget.auth, img:doc['image'], name:doc['name'], price:doc['cost'],available:doc['available'],added:false);
        });
  }


  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      //let's start by the appbar
      appBar: AppBar(
        backgroundColor: Color(0xFFfcfcfc),
        title: Text(
          "Food Court",
          style: TextStyle(
            color: Color(0xFFfc6a26),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
              child: new Text('signout'),
              onPressed: () {
                _signOut();
              }),
        ],
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ),

      //Now let's build the body of our app
      body:index==0?filter?StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("food")
                        .where(
                          'type',
                          isEqualTo:filterType,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      if (snapshot.hasError) return CircularProgressIndicator();
                      return _buildGride(snapshot.data);
                    },
                  ):Padding(
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
            Padding(
              padding: EdgeInsets.only(left: 290),
              child: PopupMenuButton(
                
                child: Icon(Icons.filter_list_alt),
                itemBuilder: (BuildContext context){
                  return {'breakfast', 'meals'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                        value: choice,
                                        child: Button(choice));
                                  }).toList(); 
                },
              ),
            ),
              
            
            //build the food menu
            //I'm going to create a custom widget
            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("food").snapshots(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) return LinearProgressIndicator();
                if (snapshot.hasError) return CircularProgressIndicator();
                return Expanded(child: _buildGride(snapshot.data));
              },
            )
          ],
        ),
      ):index==1?favourite(
        auth: widget.auth,
      ): index==2?Loader():index==3?Loader():null,

      // create the bottom bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFfcfcfc),
        elevation: 0.0,
        currentIndex: index,
        onTap: (int value) {
          checkIndex(value);
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Color(0xFFf68634),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Favorite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }


  checkIndex(int currentIndex) {
    setState(() {
      index = currentIndex;
      filter = false;
    });
  }

Widget Button(String filtersType){
  return FlatButton(onPressed: (){
    setState(() {
      print(filtersType);
      filterType = filtersType;
      filter = true;
    });
  }, child: Text(filtersType));

}
}