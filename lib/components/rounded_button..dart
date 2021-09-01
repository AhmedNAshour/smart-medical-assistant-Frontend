import 'package:flutter/material.dart';
import 'package:chatbot/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.press,
    this.text,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  final Function press;
  final String text;
  final Color color, textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.08,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FlatButton(
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
      ),
    );
  }
}
