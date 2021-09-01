import 'package:chatbot/models/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItems {
  static const chat = DrawerItem(title: 'المحادثة', icon: Icons.chat);
  static const reports =
      DrawerItem(title: 'التقرير الطبي', icon: FontAwesomeIcons.fileMedical);
  static const map = DrawerItem(title: 'الخريطة', icon: Icons.map);
  static const logout = DrawerItem(title: 'تسجيل الخروج', icon: Icons.logout);

  static final List<DrawerItem> all = [
    chat,
    reports,
    map,
    logout,
  ];
}
