import 'package:flutter/material.dart';
import 'package:komittab/components/custom_suffix_icon.dart';
import 'package:komittab/components/defaultButton.dart';
import 'package:komittab/components/form_error.dart';
import 'package:komittab/components/socal_card.dart';
import 'package:komittab/screens/Home/home_screen.dart';
import 'package:komittab/screens/Login_page/Components/sign_in.dart';
import 'package:komittab/screens/MyTask/My_Task_Home.dart';
// import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  //untuk remmember login
  SharedPreferences logindata;
  bool newuser;
  List<String> loginDataPre = [];
  bool remember = false;

  final _formKey = GlobalKey<FormState>();
  String emailform;
  String password;
  final List<String> errors = [];

  @override
  void initState() {
    super.initState();
    checkRememberLoginTrue();
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                signIn(emailform, password);
                Navigator.pushNamed(context, MyTask.routeName);
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.06),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocalCard(
                icon: "assets/icons/google-icon.svg",
                press: () {
                  print("dataaaaaaaa");

                  signInWithGoogle().then((result) {
                    if (result != null) {
                      logindata.setBool('login', false);
                      logindata.setBool('ShowSplash', false);
                      loginDataPre.add(name);
                      loginDataPre.add(email);
                      loginDataPre.add(imageUrl);
                      loginDataPre.add(provider);
                      logindata.setStringList('loginDataPre', loginDataPre);
                      print(loginDataPre);
                      print("dataaaaaaaaaaaaaaa");
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    }
                  });
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
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => emailform = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  void checkRememberLoginTrue() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);

    if (newuser == false) {
      Navigator.pushNamed(context, MyTask.routeName);
    }
  }
}
