import 'package:chatbot/constants.dart';
import 'package:chatbot/models/drawer_item.dart';
import 'package:chatbot/screens/chat.dart';
import 'package:chatbot/screens/drawer_widget.dart';
import 'package:chatbot/screens/login.dart';
import 'package:chatbot/screens/map.dart';
import 'package:chatbot/screens/reportScreen.dart';
import 'package:chatbot/screens/reports.dart';
import 'package:chatbot/services/auth.dart';
import 'package:chatbot/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/drawer_items.dart';
import 'models/user.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  double xOffset;
  double yOffset;
  double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen;
  DrawerItem item = DrawerItems.chat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    closeDrawer();
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  void openDrawer() {
    setState(() {
      xOffset = -60;
      yOffset = 150;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void setDrawerItem(DrawerItem item) {
    setState(() {
      this.item = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);

    if (user == null) {
      return Login();
    } else {
      return StreamProvider<UserModel>.value(
        value: DatabaseService(uid: user.uid).userData,
        child: StreamBuilder(
            stream: DatabaseService()
                .getReports(userID: user.uid, status: 'pending'),
            builder: (context, reports) {
              return Scaffold(
                backgroundColor: kPrimaryColor,
                body: Stack(
                  children: [
                    buildDrawer(),
                    buildPage(),
                  ],
                ),
              );
            }),
      );
      // return Chat();
    }
  }

  buildDrawer() {
    return Container(
      width: 200,
      child: DrawerWidget(
        onSelectedItem: (item) {
          switch (item) {
            case DrawerItems.logout:
              AuthService().signOut();
              closeDrawer();
              return;
            default:
              setState(() {
                this.item = item;
                closeDrawer();
              });
          }
        },
      ),
    );
  }

  buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return false;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = -1;
          if (details.delta.dx < delta) {
            openDrawer();
          } else if (details.delta.dx > -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                color: isDrawerOpen ? Colors.white : Colors.white,
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getDrawerPage() {
    switch (item) {
      case DrawerItems.chat:
        return Chat(
          openDrawer: openDrawer,
          setDrawerItem: setDrawerItem,
        );
      case DrawerItems.reports:
        return Report(
          setDrawerItem: setDrawerItem,
          openDrawer: openDrawer,
        );
      case DrawerItems.map:
        return CovidMap(
          openDrawer: openDrawer,
        );
      default:
        return Chat(
          openDrawer: openDrawer,
          setDrawerItem: setDrawerItem,
        );
    }
  }
}
