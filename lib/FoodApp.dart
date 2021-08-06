import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahyadri_food_court/widgets/about_us.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/home_page.dart';
import 'package:sahyadri_food_court/widgets/orders.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authentication/auth.dart';
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
 
  int index = 0;
  String? fid = '';
  String email = '';
  String name = '';

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
    getid();
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
          centerTitle: true,
          elevation: 0.0,
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
                      Icons.person,
                      color: Color(0xFFfc6a26),
                    ),
                    title: Text("Account"),
                    subtitle: Text("Faculty Id:$fid"),
                    
                    onTap: () {},
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
                          child: AutoSizeText(
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
            ? Home_page(auth: widget.auth)
            : index == 1
                ? favourite(
                    auth: widget.auth,
                  )
                : index == 2
                    ? Orders(auth: widget.auth, fid: fid.toString())
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
              icon: FaIcon(FontAwesomeIcons.cartArrowDown),
              title: Text("Cart"),
            ),
          ],
        ),
      ),
    );
  }

  checkIndex(int currentIndex) async {
    setState(() {
      index = currentIndex;
      filter = false;
    });
  }
}
