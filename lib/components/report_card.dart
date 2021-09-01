// import 'package:chatbot/models/report.dart';
// import 'package:chatbot/screens/reportScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';

// class ReportCard extends StatelessWidget {
//   final ReportModel report;

//   const ReportCard({Key key, this.report}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, Report.id, arguments: report);
//       },
//       child: Align(
//         child: Card(
//           margin: EdgeInsets.only(bottom: size.height * 0.02),
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Container(
//             width: size.width * 0.9,
//             padding: EdgeInsets.all(size.width * 0.04),
//             child: Row(
//               children: [
//                 FaIcon(FontAwesomeIcons.fileMedical),
//                 SizedBox(
//                   width: size.width * 0.04,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Session date: ${DateFormat("MMM").format(report.dateCreated)} ${DateFormat("d").format(report.dateCreated)} - ${DateFormat("jm").format(report.dateCreated)}',
//                     ),
//                     Text(
//                       'Model result: ${report.modelResult}',
//                     ),
//                     report.status == 'pending'
//                         ? Text(
//                             'Lab result: Pending confirmation',
//                           )
//                         : Text(
//                             'Lab result: ${report.labResult}',
//                           ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
