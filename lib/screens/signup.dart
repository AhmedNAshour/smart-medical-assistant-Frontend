import 'package:chatbot/components/rounded_button..dart';
import 'package:chatbot/components/rounded_input_field.dart';
import 'package:chatbot/constants.dart';
import 'package:chatbot/services/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String emailSignup = '';
  String passwordSignup = '';
  String fName = '';
  String lName = '';
  int age;
  String error = '';
  Gender gender = Gender.female;
  DateTime pickedDate = DateTime.now();
  bool loading = false;
  final _formKey2 = GlobalKey<FormState>();
  var dateTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading == false
        ? SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        bottom: size.height * 0.01),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: size.height * 0.001,
                          color: kPrimaryLightColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: kPrimaryTextColor,
                            size: size.width * 0.085,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: size.width * 0.25),
                        Text(
                          'إنشاء حساب',
                          style: TextStyle(
                              fontSize: size.width * 0.05,
                              color: kPrimaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  SizedBox(height: size.height * 0.02),
                  //Gender switch
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                gender = Gender.male;
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
                                color: gender == Gender.male
                                    ? kPrimaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: gender == Gender.male
                                      ? Colors.transparent
                                      : kPrimaryLightColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ذكر',
                                  style: TextStyle(
                                    color: gender == Gender.male
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
                                gender = Gender.female;
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
                                color: gender == Gender.female
                                    ? kPrimaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: gender == Gender.female
                                      ? Colors.transparent
                                      : kPrimaryLightColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'أنثى',
                                  style: TextStyle(
                                    color: gender == Gender.female
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
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  RoundedInputField(
                    labelText: 'الاسم الأول',
                    obsecureText: false,
                    icon: Icons.person_add_alt,
                    hintText: 'الاسم الأول',
                    onChanged: (val) {
                      setState(() => fName = val);
                    },
                    validator: (val) => val.isEmpty ? 'أدخل اسمًا' : null,
                  ),
                  RoundedInputField(
                    labelText: 'اسم العائلة',
                    obsecureText: false,
                    icon: Icons.person_add_alt,
                    hintText: 'اسم العائلة',
                    onChanged: (val) {
                      setState(() => lName = val);
                    },
                    validator: (val) => val.isEmpty ? 'أدخل اسمًا' : null,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: size.width * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      controller: dateTextController,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1930),
                          lastDate: DateTime.now(),
                        ).then((value) => setState(() {
                              if (value != null) {
                                setState(() {
                                  pickedDate = value;
                                  dateTextController.text =
                                      DateFormat('yyyy-MM-dd').format(value);
                                  age = (DateTime.now()
                                              .difference(pickedDate)
                                              .inDays /
                                          365)
                                      .floor();
                                });
                              }
                            }));
                      },
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: 'تاريخ الميلاد',
                        labelStyle: TextStyle(
                          color: kPrimaryColor,
                        ),
                        icon: Icon(
                          Icons.calendar_today,
                          color: kPrimaryTextColor,
                        ),
                        hintText: 'التاريخ',
                        focusColor: kPrimaryColor,
                      ),
                      // onChanged: (val) {
                      //   setState(() => age = int.parse(val));
                      // },
                      validator: (val) =>
                          val.isEmpty ? 'أدخل تاريخاً صالحًا' : null,
                    ),
                  ),
                  RoundedInputField(
                    labelText: 'البريد الإلكتروني',
                    icon: Icons.email,
                    obsecureText: false,
                    hintText: 'البريد الإلكتروني',
                    onChanged: (val) {
                      setState(() => emailSignup = val);
                    },
                    validator: (val) =>
                        val.isEmpty ? 'أدخل بريدًا إلكترونيًا' : null,
                  ),
                  RoundedInputField(
                    labelText: 'كلمة المرور',
                    obsecureText: true,
                    icon: Icons.lock,
                    hintText: 'كلمة المرور',
                    onChanged: (val) {
                      setState(() => passwordSignup = val);
                    },
                    validator: (val) => val.length < 6
                        ? ' أدخل كلمة مرور مكونة من 6 أحرف أو أكثر '
                        : null,
                  ),
                  RoundedButton(
                    text: 'سجل',
                    press: () async {
                      setState(() {
                        loading = true;
                      });
                      if (_formKey2.currentState.validate()) {
                        dynamic result =
                            await AuthService().registerWithEmailAndPasword(
                          email: emailSignup,
                          password: passwordSignup,
                          fName: fName,
                          lName: lName,
                          age: age,
                          gender: gender == Gender.male ? 'male' : 'female',
                        );

                        if (result == null) {
                          setState(() {
                            error = 'invalid credentials';
                          });
                        } else {}
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Lottie.asset(
              'assets/animation/loading3.json',
              height: size.height * 0.4,
            ),
          );
  }
}
