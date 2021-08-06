import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderDoneAnimPage extends StatefulWidget {
  @override
  _OrderDoneAnimPageState createState() => _OrderDoneAnimPageState();
}

class _OrderDoneAnimPageState extends State<OrderDoneAnimPage> {
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/animation/order_done.json',
            repeat: false,
            reverse: true,
            animate: true,
          ),
        ),
      ),
    );
  }
}
