import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                  Opacity(opacity: 0.4, child:SizedBox(height: 140,
        child: Image(image: AssetImage('assets/images/sahyadrilogo.jpg'),),),
                 ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                      CircularProgressIndicator(
                  color: Color(0xFFfc6a26),
                ),
                SizedBox(height: 40,),
                Text("Please Wait..",
                style: TextStyle(
                  
                      color: Color(0xFFfc6a26),
                      fontSize: 18,
                    ),)
                ]
                ),
               
              ],
            ),
          ),
          ),
    );
  }
}
