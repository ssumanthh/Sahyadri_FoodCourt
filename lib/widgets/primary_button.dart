import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatefulWidget {
  PrimaryButton(
      {required this.key,
      required this.text,
      required this.height,
      required this.onPressed})
      : super(key: key);
  Key key;
  String text;
  double height;
  VoidCallback onPressed;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: BoxConstraints.expand(height: widget.height + 5),
      child: new RaisedButton(
          child: new Text(widget.text,
              style: new TextStyle(color: Colors.white, fontSize: 20.0)),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          color: Color(0xFFf68634),
          textColor: Colors.black87,
          onPressed: widget.onPressed),
    );
  }
}
