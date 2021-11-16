import 'package:flutter/material.dart';
import 'package:komittab/screens/login_page/components/body.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/loginPage";
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Body(),
    );
  }
}
