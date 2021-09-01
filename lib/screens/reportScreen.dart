import 'dart:convert';

import 'package:chatbot/components/drawer_items.dart';
import 'package:chatbot/components/drawer_menu_widget.dart';
import 'package:chatbot/constants.dart';
import 'package:chatbot/models/report.dart';
import 'package:chatbot/models/user.dart';
import 'package:chatbot/services/database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  final VoidCallback openDrawer;
  final Function setDrawerItem;

  const Report({Key key, this.openDrawer, this.setDrawerItem})
      : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool labResult = false;
  bool firstTime = true;
  List reportData = [];
  bool loading = false;

  Future<String> diagnose(var body, String userID) async {
    var client = new http.Client();
    var uri = Uri.parse("https://chatbot-gp.herokuapp.com/updatePrediction");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await client.post(uri, headers: headers, body: jsonString);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        var result = json.decode(resp.body);

        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

  Widget buildReport(ReportModel report, Size size, AuthUser user) {
    if (report == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لا يوجد تقرير',
              style: TextStyle(
                fontSize: size.width * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'يرجي عمل تشخيص لكي يوجد تقرير',
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: RawMaterialButton(
                onPressed: () async {
                  widget.setDrawerItem(DrawerItems.chat);
                },
                child: Container(
                  height: size.height * 0.06,
                  width: size.width * 0.45,
                  color: kPrimaryColor,
                  child: Center(
                    child: Text(
                      'ابدأ محادثة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (report.status == 'pending') {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Align(
            //   alignment: Alignment.center,
            //   child: SvgPicture.asset(
            //     'assets/img/aiOnboard.svg',
            //     height: size.height * 0.15,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text(
                'التقرير الجاري',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Text(
                'من فضلك قم بتزويدي بنتيجة تحليل الPCR لكي اتمكن من تحسين قدراتي علي التشخيص , و قم بتعديل الاعراض اذا توجب.',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: size.width * 0.045,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text(
                'التشخيص المبدئي: ' +
                    (report.modelResult == false ? 'سلبي' : 'ايجابي'),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              height: size.height * 0.3,
              child: ListView.builder(
                itemCount: reportData.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: size.height * 0.05,
                    child: SwitchListTile(
                      // tileColor: Color(0xFFF0F0F0),
                      activeColor: kPrimaryColor,
                      value: reportData[index]['value'],
                      title: Text(
                        reportData[index]['name'],
                        style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.width * 0.06),
                      ),
                      onChanged: (value) async {
                        setState(() {
                          reportData[index]['value'] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),

            Center(
              child: Container(
                height: size.height * 0.001,
                width: size.width * 0.5,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text(
                'بعد عمل مسحة الPCR تبين ان الحالة:',
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          labResult = true;
                        });
                      },
                      child: Container(
                        // width: size.width * 0.35,
                        // height: size.height * 0.07,
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color:
                              labResult == true ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: labResult == true
                                ? Colors.transparent
                                : kPrimaryLightColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'ايجابي',
                            style: TextStyle(
                              color: labResult == true
                                  ? Colors.white
                                  : kPrimaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          labResult = false;
                        });
                      },
                      child: Container(
                        // width: size.width * 0.35,
                        // height: size.height * 0.07,
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color:
                              labResult == false ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: labResult == false
                                ? Colors.transparent
                                : kPrimaryLightColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'سلبي',
                            style: TextStyle(
                              color: labResult == false
                                  ? Colors.white
                                  : kPrimaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      if (report.labResult == true && report.status != 'recovered') {
        return Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/animation/loading3.json',
                height: size.height * 0.4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Text(
                  'أتمنى أن تكون بخير ، يرجى إعلامي إذا تعافيت من الفيروس',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: RawMaterialButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    var body = [
                      {
                        'values': [
                          reportData[0]['value'],
                          reportData[1]['value'],
                          reportData[2]['value'],
                          reportData[3]['value'],
                          reportData[4]['value'],
                          reportData[5]['value'],
                          reportData[6]['value'],
                          reportData[7]['value'],
                          reportData[8]['value'],
                          reportData[9]['value'],
                        ]
                      }
                    ];

                    await DatabaseService(uid: user.uid).updateReport(
                      userID: user.uid,
                      docID: report.docID,
                      status: 'recovered',
                      fever: report.fever,
                      tiredness: report.tiredness,
                      dryCough: report.dryCough,
                      difficultyBreathing: report.difficultyBreathing,
                      soreThroat: report.soreThroat,
                      pains: report.pains,
                      nasalCongestion: report.nasalCongestion,
                      runnyNose: report.runnyNose,
                      diarrhea: report.diarrhea,
                      smellTasteLoss: report.smellTasteLoss,
                      modelResult: report.modelResult,
                      labResult: labResult,
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.45,
                    color: kPrimaryColor,
                    child: Center(
                      child: Text(
                        'لقد تعافيت',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'لا يوجد تقرير',
                style: TextStyle(
                  fontSize: size.width * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'يرجي عمل تشخيص لكي يوجد تقرير',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: RawMaterialButton(
                  onPressed: () async {
                    widget.setDrawerItem(DrawerItems.chat);
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.45,
                    color: kPrimaryColor,
                    child: Center(
                      child: Text(
                        'ابدأ محادثة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);

    return SafeArea(
      child: FutureBuilder(
        future: DatabaseService(uid: user.uid).getReport(),
        builder: (context, reports) {
          ReportModel report = new ReportModel();
          report = reports.data;

          if (firstTime == true && reports.hasData) {
            reportData = [
              {'name': 'حمي', 'value': report.fever},
              {'name': 'ارهاق', 'value': report.tiredness},
              {'name': 'سعال', 'value': report.dryCough},
              {'name': 'ضيق التنفس', 'value': report.difficultyBreathing},
              {'name': 'احتقان الحلق', 'value': report.soreThroat},
              {'name': 'الام', 'value': report.pains},
              {'name': 'احتقان الانف', 'value': report.nasalCongestion},
              {'name': 'سيلان الانف', 'value': report.runnyNose},
              {'name': 'اسهال', 'value': report.diarrhea},
              {'name': 'فقدان الشم او التذوق', 'value': report.smellTasteLoss},
            ];
            labResult = report.labResult;
            firstTime = false;
          }

          return Scaffold(
            appBar: loading
                ? null
                : AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: DrawerMenuWidget(
                      onClicked: widget.openDrawer,
                    ),
                  ),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Opacity(
                  opacity: 1,
                  child: AbsorbPointer(
                    absorbing: loading == true ? true : false,
                    child: buildReport(report, size, user),
                  ),
                ),
                loading == true
                    ? Container(
                        width: size.width,
                        height: size.height,
                        color: Colors.grey.withOpacity(0.6),
                        child: Center(
                          child: Lottie.asset(
                            'assets/animation/loading3.json',
                            height: size.height * 0.3,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: report != null && report.status == 'pending'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: RawMaterialButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        var body = [
                          {
                            'values': [
                              reportData[0]['value'],
                              reportData[1]['value'],
                              reportData[2]['value'],
                              reportData[3]['value'],
                              reportData[4]['value'],
                              reportData[5]['value'],
                              reportData[6]['value'],
                              reportData[7]['value'],
                              reportData[8]['value'],
                              reportData[9]['value'],
                            ]
                          }
                        ];

                        var resp = await diagnose(body, user.uid);
                        await DatabaseService().updateReport(
                          userID: user.uid,
                          docID: report.docID,
                          status: 'confirmed',
                          fever: reportData[0]['value'],
                          tiredness: reportData[1]['value'],
                          dryCough: reportData[2]['value'],
                          difficultyBreathing: reportData[3]['value'],
                          soreThroat: reportData[4]['value'],
                          pains: reportData[5]['value'],
                          nasalCongestion: reportData[6]['value'],
                          runnyNose: reportData[7]['value'],
                          diarrhea: reportData[8]['value'],
                          smellTasteLoss: reportData[9]['value'],
                          modelResult: resp == 'yes' ? true : false,
                          labResult: labResult,
                        );
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Container(
                        height: size.height * 0.06,
                        width: size.width * 0.45,
                        color: kPrimaryColor,
                        child: Center(
                          child: Text(
                            'تأكيد',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          );
        },
      ),
    );
  }
}
