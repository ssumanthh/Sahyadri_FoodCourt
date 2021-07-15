

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sahyadri_food_court/authentication/auth.dart';

class Load extends StatefulWidget {
  Load({required this.auth, required this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _LoadState createState() => new _LoadState();
}

class _LoadState extends State<Load>{

@override
 Widget build (BuildContext context){
   void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }
   return Scaffold(
     appBar: AppBar(
        title: Text('admin'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          RaisedButton(
              child: new Text('signout'),
              onPressed: () {
                _signOut();
              }),
        ],
      ),
     backgroundColor :  Color(0xFF75A2EA),
     body: Center(//here we need to add fooodCourt stock updating code
       child:CircularProgressIndicator(
          color: Colors.blue,
         )
     )  
     );

 }
}