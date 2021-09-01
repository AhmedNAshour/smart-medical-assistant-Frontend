import 'package:chatbot/components/customBottomSheets.dart';
import 'package:chatbot/components/rounded_button..dart';
import 'package:chatbot/components/rounded_input_field.dart';
import 'package:chatbot/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:chatbot/constants.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  String email = '';
  String password = '';

  List onboardingData = [
    {
      'img': 'assets/img/chatOnboard.svg',
      'title': 'تحقق من الأعراض',
      'subtitle': 'تحدث معي حول أعراضك وتلقي تشخيصًا أوليًا.',
    },
    {
      'img': 'assets/img/labOnboard.svg',
      'title': 'احصل على فحص',
      'subtitle': 'احصل على اختبار معملي للتأكد من نتيجتك.',
    },
    {
      'img': 'assets/img/aiOnboard.svg',
      'title': 'ساعدني على التحسن',
      'subtitle':
          'اعطني نتيجة التحليل الخاصة بك لمساعدتي في التشخيص بشكل أفضل.',
    },
    {
      'img': 'assets/img/map.svg',
      'title': 'تابع انتشار الفيروس',
      'subtitle': 'كن على دراية بالمناطق التي يوجد بها المصابين بالفيروس',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.5,
                        child: Swiper(
                          autoplayDisableOnInteraction: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                SvgPicture.asset(
                                  onboardingData[index]['img'],
                                  height: size.height * 0.3,
                                ),
                                SizedBox(height: size.height * 0.03),
                                Text(
                                  onboardingData[index]['title'],
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: size.width * 0.07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.015),
                                Text(
                                  onboardingData[index]['subtitle'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                          autoplay: true,
                          loop: true,
                          itemCount: onboardingData.length,
                          pagination: new SwiperPagination(
                            margin: EdgeInsets.only(top: size.height * 0.02),
                            builder: const DotSwiperPaginationBuilder(
                              space: 10.0,
                              activeColor: kPrimaryColor,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                      RoundedInputField(
                        labelText: 'البريد الإلكتروني',
                        icon: Icons.email,
                        obsecureText: false,
                        hintText: 'البريد الإلكتروني',
                        onChanged: (val) {
                          setState(() => email = val);
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
                          setState(() => password = val);
                        },
                        validator: (val) => val.length < 6
                            ? ' أدخل كلمة مرور مكونة من 6 أحرف أو أكثر '
                            : null,
                      ),
                      Container(
                        width: size.width * 0.8,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              // await _auth.signOut();
                              // Navigator.pushNamed(context, ResetPassword.id);
                              CustomBottomSheets().showCustomBottomSheet(
                                  size, Signup(), context);
                            },
                            child: Text(
                              'مستخدم جديد ؟ سجل من هنا',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      RoundedButton(
                        text: 'تسجيل الدخول',
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'حدث خطأ في الدخول';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
