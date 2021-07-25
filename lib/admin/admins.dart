

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/admin/admin_order.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/foodcard.dart';

class Admin extends StatefulWidget {
  Admin({required this.auth, required this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
  
  
  Widget _buildGride(QuerySnapshot? snapshot) {
    return ListView.builder(
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index]; 
          print(doc.id);
          TextEditingController availableControler = new TextEditingController();
          availableControler.text=doc['available'].toString();
      return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          isThreeLine: true,
                          leading:Image.network(
              doc['image'],
              height: 70.0,
            ),
          
                          title: Text(
                    doc['name'],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                          subtitle: Text(
                    "${doc['available']}\n${doc['cost']} ₹",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [  
                            //button to make calls
                            SizedBox(width:100,child: 
                            new TextField(
                              keyboardType: TextInputType.phone,
                              controller:availableControler ,
                              cursorColor:Color(0xFFf68634),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Color(0xFFf68634)), ),
                                
                                 focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Color(0xFFf68634)), ),
                                labelStyle:TextStyle(
                      color: Color(0xFFf68634),
                    ),
                                labelText: 'available',
                              ),
                            ),
                            ),
                            //button to send msg
                            new RaisedButton(
          child: new Text('Submit',
              style: new TextStyle(color: Colors.white, fontSize: 10.0)),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          color: Color(0xFFf68634),
          textColor: Colors.black87,
          onPressed:(){
            print(availableControler.text);
            FirebaseFirestore.instance.collection('food').doc(doc.id).set({'available':int.parse(availableControler.text) }, SetOptions(merge: true)).then((value) => print("succues"));
          }),
                          ],
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  );
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
          "Admin",
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
      body: index==0? Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Let's create the welcoming Text
            Text(
              "Hello Admin \n ",
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
      ):AdminOdrder(auth: widget.auth),
      
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
            title: Text("Orders"),
          ),
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
