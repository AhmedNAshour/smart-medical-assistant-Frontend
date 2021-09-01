import 'package:chatbot/components/drawer_items.dart';
import 'package:chatbot/constants.dart';
import 'package:chatbot/models/drawer_item.dart';
import 'package:chatbot/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;

  const DrawerWidget({Key key, this.onSelectedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.02),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidUserCircle,
                    color: Colors.white,
                    size: size.width * 0.15,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    user.fName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  buildDrawerItems(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: DrawerItems.all
          .map(
            (item) => ListTile(
              leading: Icon(
                item.icon,
                color: Colors.white,
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => onSelectedItem(item),
            ),
          )
          .toList(),
    );
  }
}
