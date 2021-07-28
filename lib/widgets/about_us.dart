import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
              height: 40,
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
              height: 300,
              child: Container(
                padding: EdgeInsets.fromLTRB(30.0, 0, 12.0, 15.0),
                child: Center(
                  child: Text(
                      ' This App is mainly devoleped for the faculties of the Sahyadri College Of Engineering & Management where the can see the food available in the FoodCourt and order the food once the go to FoodCourt they can confirm the order  ',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 20,
                      )),
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
              padding: EdgeInsets.fromLTRB(20, 15, 20, 30),
              child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                child: Text('Sumanth Prabhu',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ))),
                          ),
                          Center(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 2.0, 0, 8.0),
                                child: Text('Developer',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ))),
                          ),
                          Center(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0.0, 0, 10.0),
                                child: Text('Know More',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ))),
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
                                      fontSize: 15,
                                    ))),
                          ),
                          Center(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 2.0, 0, 8.0),
                                child: Text('Developer',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ))),
                          ),
                          Center(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0.0, 0, 10.0),
                                child: Text('Know More',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ))),
                          ),
                        ],
                      ),
                    
                    ],
                  ),
                
            ),
          ],
        ),
      ),
    );
  }
}
