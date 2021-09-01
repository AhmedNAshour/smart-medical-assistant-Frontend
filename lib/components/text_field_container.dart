import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: size.width * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: child,
    );
  }
}
