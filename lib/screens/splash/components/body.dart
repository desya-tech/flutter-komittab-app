import 'package:flutter/material.dart';
import 'package:komittab/components/defaultButton.dart';
import 'package:komittab/screens/Login_Page/Login_page.dart';
import 'package:komittab/screens/MyTask/My_Task_Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
// This is the best practice
import '../../../constants.dart';
import '../../../size_config.dart';
import '../components/splash_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SharedPreferences logindata;
  bool newuser;
  bool splash;
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to KomitTab, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "We help people conect with store \naround United State of America",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    checkRememberLoginTrue();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        logindata.setBool('ShowSplash', false);
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  void checkRememberLoginTrue() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    splash = (logindata.getBool('ShowSplash') ?? true);

    if (newuser == false && splash == false) {
      Navigator.pushNamed(context, MyTask.routeName);
    } else if (splash == false && newuser == true) {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
  }
}
