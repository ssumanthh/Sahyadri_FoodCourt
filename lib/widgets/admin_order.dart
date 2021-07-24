import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/widgets/favourite.dart';
import 'package:sahyadri_food_court/widgets/loader.dart';

class AdminOdrder extends StatefulWidget {
  const AdminOdrder({ Key? key }) : super(key: key);

  @override
  _AdminOdrderState createState() => _AdminOdrderState();
}

class _AdminOdrderState extends State<AdminOdrder> {
  @override
  Widget build(BuildContext context) {
  
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
      ));
  }
}