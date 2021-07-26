import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/home_page.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';
import 'package:sahyadri_food_court/widgets/loding.dart';
import 'package:sahyadri_food_court/widgets/orders.dart';
import 'authentication/auth.dart';
import 'widgets/foodcard.dart';

class FoodApp extends StatefulWidget {
  FoodApp({required this.auth, required this.onSignOut, required this.index});
  final BaseAuth auth;
  final index;
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
  String? fid = '';
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

  void getid() async {
    await widget.auth.getfid().then((value) async {
      setState(() {
        fid = value;
      });
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
      body: index == 0
          ? Home_page(auth: widget.auth)
          : index == 1
              ? favourite(
                  auth: widget.auth,
                )
              : index == 2
                  ? Orders(auth: widget.auth, fid: fid.toString())
                  : index == 3
                      ? Loading()
                      : null,

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

  checkIndex(int currentIndex) async {
    if (currentIndex == 2) {
      await widget.auth.getfid().then((value) async {
        setState(() {
          fid = value;
          index = currentIndex;
          filter = false;
        });
      });
    } else {
      setState(() {
        index = currentIndex;
        filter = false;
      });
    }
  }
}
