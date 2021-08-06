
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AbooutUs extends StatefulWidget {
  @override
  _Information createState() => new _Information();
}

class _Information extends State<AbooutUs> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                height: 48,
                child: Center(
                  child: Text('Mission',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 240,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30.0, 0, 12.0, 15.0),
                    child: Center(
                      child: Text(
                          ' This App is mainly devoleped for the faculties of the Sahyadri College Of Engineering & Management where they can see the food available in the FoodCourt and order the food. Once they go to FoodCourt they can confirm the order  ',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 20,
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(120, 0, 120, 0),
                    height: 5,
                    decoration: BoxDecoration(color: Color(0xFFfc6a26)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                height: 60,
                child: Center(
                  child: Text('Our team',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 15, 20, 30),
                child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image:
                                      new AssetImage("assets/images/sumanth.jpg"),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(0.5, 3.0),
                                      blurRadius: 10.0),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                                  child:Text('Sumanth Prabhu',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  ),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 2.0, 0, 8.0),
                                  child: Text('Developer',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ))),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0.0, 0, 10.0),
                                  child: Row(
                                    children: [
                                      IconButton(onPressed: () async {
                                        await canLaunch("https://wa.me/+918748929010/?") ? await launch("https://wa.me/+918748929010/?") : throw 'Could not launch "https://wa.me/+918748929010/?"';
                                      }, icon: FaIcon(FontAwesomeIcons.whatsapp)),
                                       IconButton(onPressed: () async {
                                         await canLaunch("https://www.linkedin.com/in/sumanth-prabhu-6290671a8") ? await launch("https://www.linkedin.com/in/sumanth-prabhu-6290671a8") : throw 'Could not launch "https://www.linkedin.com/in/sumanth-prabhu-6290671a8"';
                                       }, icon: FaIcon(FontAwesomeIcons.linkedinIn))
                                   ],
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image:
                                      new AssetImage("assets/images/rakshith.jpg"),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(0.5, 3.0),
                                      blurRadius: 10.0),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                                  child: Text('Rakshith Raju',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ))),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 2.0, 0, 8.0),
                                  child: Text('Developer',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ))),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 2.0, 0, 8.0),
                                  child: Row(
                                    children: [
                                      IconButton(onPressed: () async {
                                        await canLaunch("https://wa.me/+919480652047/?") ? await launch("https://wa.me/+919480652047/?") : throw 'Could not launch "https://wa.me/+919480652047/?"';
                                      }, icon: FaIcon(FontAwesomeIcons.whatsapp)),
                                       IconButton(onPressed: () async {
                                         await canLaunch("https://www.linkedin.com/in/rakshith-raju-n-74b4101aa") ? await launch("https://www.linkedin.com/in/rakshith-raju-n-74b4101aa") : throw 'Could not launch "https://www.linkedin.com/in/rakshith-raju-n-74b4101aa"';
                                       }, icon: FaIcon(FontAwesomeIcons.linkedinIn))
                                    ],
                                  )),
                                  ),
                            
                            
                          ],
                        ),
                      
                      ],
                    ),
                  
              ),
            ],
          ),
        ),
      ),
    );
  }
}
