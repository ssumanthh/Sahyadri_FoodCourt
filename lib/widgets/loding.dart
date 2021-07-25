import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingAnimPageState createState() => _LoadingAnimPageState();
}

class _LoadingAnimPageState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 80,
          height: 80,
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
      ),
    );
  }
}
