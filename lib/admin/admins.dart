import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/admin/admin_order.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';
import 'package:sahyadri_food_court/widgets/about_us.dart';
import 'package:url_launcher/url_launcher.dart';

class Admin extends StatefulWidget {
  Admin({required this.auth, required this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  CollectionReference username = FirebaseFirestore.instance.collection('food');
  
  int index = 0;
  bool search = false;
  String? fid = '';
  String email = '';
  String name = '';
  TextEditingController searchControler = TextEditingController();

  Widget _buildGride(QuerySnapshot? snapshot) {
    return ListView.builder(
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          print(doc.id);
          TextEditingController availableControler =
              new TextEditingController();
          availableControler.text = doc['available'].toString();
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  isThreeLine: true,
                  leading: Image.network(
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
                    SizedBox(
                      width: 100,
                      child: new TextField(
                        keyboardType: TextInputType.phone,
                        controller: availableControler,
                        cursorColor: Color(0xFFf68634),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFf68634)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFf68634)),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xFFf68634),
                          ),
                          labelText: 'available',
                        ),
                      ),
                    ),
                    new RaisedButton(
                        child: new Text('Submit',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 10.0)),
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        color: Color(0xFFf68634),
                        textColor: Colors.black87,
                        onPressed: () {
                          print(availableControler.text);
                          FirebaseFirestore.instance
                              .collection('food')
                              .doc(doc.id)
                              .set({
                            'available': int.parse(availableControler.text)
                          }, SetOptions(merge: true)).then(
                                  (value) => print("succues"),
                                  );
                        }),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
  }

  void getid() async {
    await widget.auth.getfid().then((value) async {
      setState(() {
        fid = value;
      });
    });
  }

  void _launchURL(String url) async {
    String _url = url;
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  void initState() {
    super.initState();
    widget.auth.currentUseremail().then((value) {
      email = value.toString();
    });
    //getid();
    widget.auth.getname().then((value) {
      name = value.toString();
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

    return SafeArea(
      child: Scaffold(
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
        ),
        drawer: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFFfc6a26)),
                    accountName: Text(name),
                    accountEmail: Text(email),
                    currentAccountPicture:
                        CircleAvatar(child: Icon(Icons.person)),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Color(0xFFfc6a26),
                    ),
                    title: Text("Email"),
                    subtitle: Text(email),
                    trailing: Icon(Icons.send),
                    onTap: () {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: 'sumanth.is18@sayhadri.edu.in',
                      );
                      _launchURL(params.toString());
                    },
                  ),
                  ListTile(
                      title: new Row(children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFFfc6a26),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          child: Text(
                            'About Us',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AbooutUs()),
                        );
                      }),
                      ListTile(
                      title: new Row(children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFFfc6a26),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          child: Text(
                            'About FoodCourt',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ]),
                      onTap: () {
                         _launchURL("https://sahyadri.edu.in/Mba/FoodCourt");
                      }),
                  ListTile(
                    title: new Row(children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Color(0xFFfc6a26),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        child: Text(
                          'logOut',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ]),
                    onTap: () {
                      _signOut();
                    },
                  ),
                ],
              ),
            )),
        //Now let's build the body of our app
        body: index == 0
            ? Padding(
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
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  search = true;
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
                    //build the food menu
                    //I'm going to create a custom widget
                    search
                        ?//if sreach is activated then this will be exicuted
                         StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("food")
                                .where(
                                  'name',
                                  isGreaterThanOrEqualTo: searchControler.text,
                                )
                                .where('name',
                                    isLessThan: searchControler.text + 'z')
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
                        : //display all food items
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
            : AdminOdrder(auth: widget.auth),

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
              icon: Icon(Icons.shopping_cart),
              title: Text("Orders"),
            ),
          ],
        ),
      ),
    );
  }
//bottom bar index change on press
  checkIndex(int currentIndex) {
    setState(() {
      index = currentIndex;
    });
  }
}
