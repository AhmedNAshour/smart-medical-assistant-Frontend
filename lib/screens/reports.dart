// import 'package:chatbot/components/drawer_menu_widget.dart';
// import 'package:chatbot/components/report_card.dart';
// import 'package:chatbot/components/reports_list.dart';
// import 'package:chatbot/models/user.dart';
// import 'package:chatbot/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';

// class ReportsScreen extends StatefulWidget {
//   final VoidCallback openDrawer;

//   const ReportsScreen({Key key, this.openDrawer}) : super(key: key);
//   @override
//   _ReportsScreenState createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final user = Provider.of<AuthUser>(context);

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: DrawerMenuWidget(
//           onClicked: widget.openDrawer,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               child: StreamProvider.value(
//                 value: DatabaseService().getReports(
//                   userID: user.uid,
//                 ),
//                 child: ReportsList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
