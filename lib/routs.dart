import 'package:flutter/widgets.dart';
import 'package:komittab/screens/Home/components/add_event.dart';
import 'package:komittab/screens/Home/home_screen.dart';
import 'package:komittab/screens/Login_Page/Login_page.dart';
import 'package:komittab/screens/MyTask/My_Task_Home.dart';
import 'package:komittab/screens/Sign_Up/sign_up_screen.dart';
import 'package:komittab/screens/Splash/splash_screen.dart';
import 'package:komittab/screens/otp/otp_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  MyTask.routeName: (context) => MyTask(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  AddEventPage.routeName: (context) => AddEventPage()
};
