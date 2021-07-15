

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Loader extends StatefulWidget{
  @override
  _LoaderState createState()=>_LoaderState();
}

class _LoaderState extends State<Loader>{

@override
 Widget build (BuildContext context){
   return Scaffold(
     backgroundColor :  Color(0xFF75A2EA),
     body: Center(
       child:CircularProgressIndicator(
          color: Colors.white,
         )
     )  
     );

 }
}