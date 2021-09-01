import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:chatbot/components/drawer_items.dart';
import 'package:chatbot/components/drawer_menu_widget.dart';
import 'package:chatbot/components/rounded_button..dart';
import 'package:chatbot/constants.dart';
import 'package:chatbot/models/report.dart';
import 'package:chatbot/models/user.dart';
import 'package:chatbot/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final VoidCallback openDrawer;
  final Function setDrawerItem;

  const Chat({Key key, this.openDrawer, this.setDrawerItem}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  // static Uri url =
  //     Uri.parse("https://flutter-medical-chatbot.herokuapp.com/bot");

  List<String> data = [];
  TextEditingController queryController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool firstTime = true;
  bool conversationEnded = false;
  bool waitingForMessage = false;
  Position currentPosition;
  String previous;
  int chatIteration;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;
  var diagnosed;
  var visited;

  Future<String> diagnose(var body, String userID) async {
    var client = new http.Client();
    var uri = Uri.parse("https://chatbot-gp.herokuapp.com/predict");
    var resetUri = Uri.parse("https://chatbot-gp.herokuapp.com/resetData");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await client.post(uri, headers: headers, body: jsonString);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        var result = json.decode(resp.body);
        setState(() {
          chatIteration = result['chatIteration'];
          previous = result['previous'];
          visited = result['visited'];
          diagnosed = result['diagnosed'];
        });
        locatePosition();
        if (result['trace'] != null) {
          print('TRACING RESULT: ' + result['trace']);
          return result['trace'];
        }
        if (result["dict"] != null) {
          var resp =
              await client.post(resetUri, headers: headers, body: jsonString);
          DatabaseService ds = new DatabaseService();
          await ds.addReport(
            userID: userID,
            status: 'pending',
            fever: result["dict"]["حمي"],
            tiredness: result["dict"]["إرهاق"],
            dryCough: result["dict"]["سعال"],
            difficultyBreathing: result["dict"]["ضيق تنفس"],
            soreThroat: result["dict"]["احتقان حلق"],
            pains: result["dict"]["آلام"],
            nasalCongestion: result["dict"]["احتقان انف"],
            runnyNose: result["dict"]["سيلان انف"],
            diarrhea: result["dict"]["اسهال"],
            smellTasteLoss: result["dict"]["فقدان حاسة الشم و التذوق"],
            modelResult:
                result["prediction"] == "تم تشخيصك بفيروس كورونا المستجد."
                    ? true
                    : false,
            labResult: false,
            lat: currentPosition.latitude,
            long: currentPosition.longitude,
          );
        }
        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

  void locatePosition() async {
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = p;
  }

  Widget buildChat(ReportModel reportModel, Size size, AuthUser user) {
    if (reportModel != null &&
        reportModel.status == 'pending' &&
        conversationEnded == false) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: DrawerMenuWidget(
            onClicked: widget.openDrawer,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation/loading3.json',
                height: size.height * 0.4,
              ),
              Text(
                'عندك تقرير جاري , برجاء المتابعة لكي تستطيع بدأ محادثة جديدة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.06,
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
                    widget.setDrawerItem(DrawerItems.reports);
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.45,
                    color: kPrimaryColor,
                    child: Center(
                      child: Text(
                        'التقرير',
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
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              'assets/animation/loading3.json',
              height: size.height * 0.4,
            ),
            Container(
              height: data.length > 2 || waitingForMessage == true
                  ? size.height * 0.34
                  : size.height * 0.38,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                key: _listKey,
                itemCount: data.length + 2,
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return Container(
                      height: size.height * 0.07,
                    );
                  }
                  if (index == data.length + 1) {
                    return Container(
                      height: size.height * 0.1,
                    );
                  }
                  return buildItem(data[index], index, size);
                },
              ),
            ),
            data.length > 2
                ? SizedBox(
                    height: size.height * 0.015,
                  )
                : Container(),
            waitingForMessage == true
                ? SpinKitThreeBounce(
                    color: kPrimaryColor,
                    size: size.width * 0.08,
                  )
                : Container(),
            data.length > 2 && !conversationEnded && waitingForMessage == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var body = [
                            {
                              'values': 'نعم',
                              'chatIteration': chatIteration,
                              'previous': previous,
                              'diagnosed': diagnosed,
                              'visited': visited,
                            }
                          ];
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                          insertSingleItem('نعم');
                          setState(() {
                            waitingForMessage = true;
                          });
                          var resp = await diagnose(body, user.uid);

                          if (resp == 'تم تشخيصك بفيروس كورونا المستجد.' ||
                              resp == 'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                            setState(() {
                              conversationEnded = true;
                            });
                          }
                          if (resp == 'تم تشخيصك بفيروس كورونا المستجد.') {
                            insertSingleItem(
                                'التشخيص المبدئي للحالة ايجابي , برجاء عمل اختبار PCR للتأكد' +
                                    '<bot>');
                          } else if (resp ==
                              'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                            insertSingleItem(
                                'التشخيص المبدئي للحالة سلبي , برجاء عمل اختبار PCR للتأكد' +
                                    '<bot>');
                          } else {
                            insertSingleItem(resp + '<bot>');
                          }
                          setState(() {
                            waitingForMessage = false;
                          });
                          queryController.clear();
                        },
                        child: Container(
                          height: size.height * 0.04,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'نعم',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.05,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      GestureDetector(
                        onTap: () async {
                          var body = [
                            {
                              'values': 'لا',
                              'chatIteration': chatIteration,
                              'previous': previous,
                              'diagnosed': diagnosed,
                              'visited': visited,
                            }
                          ];
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                          insertSingleItem('لا');
                          setState(() {
                            waitingForMessage = true;
                          });
                          var resp = await diagnose(body, user.uid);

                          if (resp == 'تم تشخيصك بفيروس كورونا المستجد.' ||
                              resp == 'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                            setState(() {
                              conversationEnded = true;
                            });
                          }
                          if (resp == 'تم تشخيصك بفيروس كورونا المستجد.') {
                            insertSingleItem(
                                'التشخيص المبدئي للحالة ايجابي , برجاء عمل اختبار PCR للتأكد' +
                                    '<bot>');
                          } else if (resp ==
                              'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                            insertSingleItem(
                                'التشخيص المبدئي للحالة سلبي , برجاء عمل اختبار PCR للتأكد' +
                                    '<bot>');
                          } else {
                            insertSingleItem(resp + '<bot>');
                          }
                          setState(() {
                            waitingForMessage = false;
                          });

                          queryController.clear();
                        },
                        child: Container(
                          height: size.height * 0.04,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'لا',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.05,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            // SizedBox(
            //   height: size.height * 0.01,
            // ),
            !conversationEnded
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 32,
                          color: kPrimaryColor.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.mic,
                        //       color: kPrimaryColor,
                        //     )),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          width: size.width * 0.8,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextField(
                            enabled: !waitingForMessage,
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'اكتب ما تشعر به...',
                              hintStyle: TextStyle(
                                color: kPrimaryTextColor,
                              ),
                            ),
                            controller: queryController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) async {
                              var body = [
                                {
                                  'values': value,
                                  'chatIteration': chatIteration,
                                  'previous': previous,
                                  'diagnosed': diagnosed,
                                  'visited': visited,
                                }
                              ];
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);

                              insertSingleItem(value);
                              setState(() {
                                waitingForMessage = true;
                              });
                              var resp = await diagnose(body, user.uid);

                              print('Response:' + resp);
                              if (resp == 'تم تشخيصك بفيروس كورونا المستجد.' ||
                                  resp ==
                                      'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                                setState(() {
                                  conversationEnded = true;
                                });
                              }
                              if (resp == 'تم تشخيصك بفيروس كورونا المستجد.') {
                                insertSingleItem(
                                    'التشخيص المبدئي للحالة ايجابي , برجاء عمل اختبار PCR للتأكد' +
                                        '<bot>');
                              } else if (resp ==
                                  'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                                insertSingleItem(
                                    'التشخيص المبدئي للحالة سلبي , برجاء عمل اختبار PCR للتأكد' +
                                        '<bot>');
                              } else {
                                insertSingleItem(resp + '<bot>');
                              }
                              setState(() {
                                waitingForMessage = false;
                              });
                              queryController.clear();
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              var body = [
                                {
                                  'values': queryController.text,
                                  'chatIteration': chatIteration,
                                  'previous': previous,
                                  'diagnosed': diagnosed,
                                  'visited': visited,
                                }
                              ];
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              insertSingleItem(queryController.text);
                              setState(() {
                                waitingForMessage = true;
                              });
                              var resp = await diagnose(body, user.uid);
                              if (resp == 'تم تشخيصك بفيروس كورونا المستجد.' ||
                                  resp ==
                                      'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                                setState(() {
                                  conversationEnded = true;
                                });
                              }
                              if (resp == 'تم تشخيصك بفيروس كورونا المستجد.') {
                                insertSingleItem(
                                    'التشخيص المبدئي للحالة ايجابي , برجاء عمل اختبار PCR للتأكد' +
                                        '<bot>');
                              } else if (resp ==
                                  'لم يتم تشخيصك بفيروس كورونا المستجد.') {
                                insertSingleItem(
                                    'التشخيص المبدئي للحالة سلبي , برجاء عمل اختبار PCR للتأكد' +
                                        '<bot>');
                              } else {
                                insertSingleItem(resp + '<bot>');
                              }
                              setState(() {
                                waitingForMessage = false;
                              });
                              queryController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                              textDirection: TextDirection.ltr,
                              color: kPrimaryColor,
                            )),
                      ],
                    ),
                  )
                : RoundedButton(
                    text: 'التقرير',
                    press: () async {
                      widget.setDrawerItem(DrawerItems.reports);

                      setState(() {
                        data.clear();
                        firstTime = true;
                        conversationEnded = false;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void reset() async {
    var client = new http.Client();
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode('body');
    var resetUri = Uri.parse("https://chatbot-gp.herokuapp.com/resetData");
    var resp = await client.post(resetUri, headers: headers, body: jsonString);
    previous = 'حمي';
    chatIteration = 0;
    diagnosed = {
      'حمي': false,
      'إرهاق': false,
      'سعال': false,
      'ضيق تنفس': false,
      'احتقان حلق': false,
      'آلام': false,
      'احتقان انف': false,
      'سيلان انف': false,
      'اسهال': false,
      'فقدان حاسة الشم و التذوق': false,
    };
    visited = {
      'حمي': false,
      'إرهاق': false,
      'سعال': false,
      'ضيق تنفس': false,
      'احتقان حلق': false,
      'آلام': false,
      'احتقان انف': false,
      'سيلان انف': false,
      'اسهال': false,
      'فقدان حاسة الشم و التذوق': false,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    if (firstTime) {
      insertSingleItem(
          'اهلاً , من فضلك اخبرني بالاعراض التي تشعر بها كي استطيع مساعدتك :)' +
              '<bot>');
      firstTime = false;
    }
    return FutureBuilder(
        future: DatabaseService(uid: user.uid).getReport(),
        builder: (context, reports) {
          ReportModel reportModel = reports.data;
          return buildChat(reportModel, size, user);
        });
  }

  void insertSingleItem(String message) {
    setState(() {
      data.add(message);
    });
  }

  http.Client getClient() {
    return http.Client();
  }
}

Widget buildItem(String item, int index, Size size) {
  bool mine = item.endsWith("<bot>");
  return Container(
    width: size.width * 0.3,
    alignment: mine ? Alignment.topLeft : Alignment.topRight,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: !mine
          ? Bubble(
              nip: mine ? BubbleNip.leftTop : BubbleNip.rightTop,
              color: mine ? kPrimaryColor : Colors.grey[300],
              padding: BubbleEdges.all(10),
              child: Container(
                width: item.length > 40 ? size.width * 0.5 : null,
                child: Text(
                  item.replaceAll("<bot>", ""),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: mine ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
          : Row(
              textDirection: TextDirection.ltr,
              children: [
                Lottie.asset(
                  'assets/animation/loading2.json',
                  height: size.height * 0.08,
                ),
                Bubble(
                  nip: mine ? BubbleNip.leftTop : BubbleNip.rightTop,
                  color: mine ? kPrimaryColor : Colors.grey[300],
                  padding: BubbleEdges.all(10),
                  child: Container(
                    width: item.length > 40 ? size.width * 0.5 : null,
                    child: Text(
                      item.replaceAll("<bot>", ""),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mine ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
    ),
  );
}
