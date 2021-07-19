import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'authentication/auth.dart';
import 'foodcard.dart';

class Reviews {
  String userID;
  String userName;
  late Ratings ratings;
  Reviews(
      {required this.userID, required this.userName, required this.ratings});

  factory Reviews.fromJson(Map<dynamic, dynamic> json) => Reviews(
      userID: json['UserID'],
      userName: json['UserName'],
      ratings: Ratings.fromJson(json['ratings']));

  Map<String, dynamic> toJson() => {
        "UserID": userID,
        "UserName": userName,
        "ratings": ratings.toJson(),
      };

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Ratings {
  String oneStar;
  String twoStar;
  String threeStar;
  Ratings(
      {required this.oneStar, required this.twoStar, required this.threeStar});

  factory Ratings.fromJson(Map<dynamic, dynamic> json) => Ratings(
        oneStar: json['1-star'],
        twoStar: json['2-star'],
        threeStar: json['3-star'],
      );

  Map<String, dynamic> toJson() => {
        "1-star": oneStar,
        "2-star": twoStar,
        "3-star": threeStar,
      };
}

class FoodApp extends StatefulWidget {
  FoodApp({required this.auth, required this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _FoodAppState createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> {
  CollectionReference username = FirebaseFirestore.instance.collection('food');
  //here i'm going to place a list of image url
  List<String> imgUrl = [
    "https://pngimage.net/wp-content/uploads/2018/06/idli-png-1.png",
    "https://pngimage.net/wp-content/uploads/2019/05/dosa-png-images-hd-2.jpg",
    "https://pngimage.net/wp-content/uploads/2018/06/poori-png.png",
    "https://pngimage.net/wp-content/uploads/2018/06/parota-png-1.png",
    "https://pngimage.net/wp-content/uploads/2018/06/sizzler-png-2.png",
    "https://pngimage.net/wp-content/uploads/2018/06/sizzler-png-8.png",
  ];
  int index = 0;
  Map<dynamic, dynamic> lists = {};

  final databaseReference = FirebaseDatabase().reference();

  void readData() async {
    await username.get().then((value) => value.docs.asMap());
    /*((snapshot) {
      if (snapshot.docs != null) {
        var map = snapshot.docs;
        print(map);
        if (map != null) {
          map.forEach((change) {
            //fromJson(change.data());
            print(change.data().toString().);
          });
        }
      }
    });*/
  }

  fromJson(Map<dynamic, dynamic> json) => (json) {
        print(json.keys);
      };
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('food').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          readData();
          if (!snapshot.hasData) {
            return Center(child: const Text('Loading events...'));
          }
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Text(snapshot.data.docs);
            },
            itemCount: 2,
          );
        },
      ),

      //Now let's create the bottom bar
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
    });
  }
}
