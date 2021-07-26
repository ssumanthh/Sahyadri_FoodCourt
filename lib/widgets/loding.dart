import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingAnimPageState createState() => _LoadingAnimPageState();
}

class _LoadingAnimPageState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          width: 180,
          height: 180,
          child: Opacity(
            opacity: 0.8,
            child: Lottie.asset(
              'assets/animation/loading_dish.json',
              repeat: true,
              reverse: true,
              animate: true,
            ),
          ),
        
      ),
    );
  }
}
