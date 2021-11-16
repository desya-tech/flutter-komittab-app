import 'package:flutter/material.dart';
import 'package:komittab/components/socal_card.dart';
import 'package:komittab/constants.dart';
// import 'package:komittab/screens/Login_page/Components/sign_in.dart';
// import 'package:komittab/screens/MyTask/My_Task_Home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:komittab/screens/Sign_Up/components/sign_up_form.dart';
import 'package:komittab/size_config.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // //untuk remmember login
    // SharedPreferences logindata;
    // bool newuser;
    // List<String> loginDataPre = [];
    // bool remember = false;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Register Account",
                style: headingStyle,
              ),
              Text(
                "Complete your details or continue\nwith social media",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              SignUpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocalCard(
                    icon: "assets/icons/google-icon.svg",
                    press: () {
                      // print("dataaaaaaaa");

                      // signInWithGoogle().then((result) {
                      //   if (result != null) {
                      //     logindata.setBool('login', false);
                      //     loginDataPre.add(name);
                      //     loginDataPre.add(email);
                      //     loginDataPre.add(imageUrl);
                      //     logindata.setStringList('loginDataPre', loginDataPre);
                      //     print(loginDataPre);
                      //     print("dataaaaaaaaaaaaaaa");
                      //     Navigator.pushNamed(context, MyTask.routeName);
                      //   }
                      // });
                    },
                  ),
                  SocalCard(
                    icon: "assets/icons/facebook-2.svg",
                    press: () {},
                  ),
                  SocalCard(
                    icon: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                  "By Continuing your confirm that you agree \n with our term and condition",
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
