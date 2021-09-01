import 'package:chatbot/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerMenuWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const DrawerMenuWidget({Key key, this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClicked,
      icon: FaIcon(FontAwesomeIcons.alignRight),
      color: kPrimaryColor,
    );
  }
}
