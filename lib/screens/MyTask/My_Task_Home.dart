import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:komittab/screens/Login_Page/Components/sign_in.dart';
import 'package:komittab/screens/Login_page/Login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/MyTask_Body.dart';

class MyTask extends StatefulWidget {
  static String routeName = "/myTask";
  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  SharedPreferences logindata;
  // ignore: non_constant_identifier_names
  List<String> loginDataPre = [];
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    // if (logindata.getString('email') != 0) {
    setState(() {
      loginDataPre = logindata.getStringList('loginDataPre');
    });
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double contLimit = position.dy + renderBox.size.height - 20;
    double step = (contLimit - start) / 5;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    double size =
        (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height / 2;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(255, 65, 108, 1.0),
            Color.fromRGBO(255, 75, 73, 1.0)
          ])),
          width: mediaQuery.width,
          child: Stack(
            children: <Widget>[
              MyTaskBody(),
              AnimatedPositioned(
                duration: Duration(milliseconds: 1500),
                left: isMenuOpen ? 0 : -sidebarSize + 20,
                top: 0,
                curve: Curves.elasticOut,
                child: SizedBox(
                  width: sidebarSize,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (details.localPosition.dx <= sidebarSize) {
                        setState(() {
                          _offset = details.localPosition;
                        });
                      }

                      if (details.localPosition.dx > sidebarSize - 20 &&
                          details.delta.distanceSquared > 2) {
                        setState(() {
                          isMenuOpen = true;
                        });
                      }
                    },
                    onPanEnd: (details) {
                      setState(() {
                        _offset = Offset(0, 0);
                      });
                    },
                    child: Stack(
                      children: <Widget>[
                        CustomPaint(
                          size: Size(sidebarSize, mediaQuery.height),
                          painter: DrawerPainter(offset: _offset),
                        ),
                        Container(
                          height: mediaQuery.height,
                          width: sidebarSize,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                height: mediaQuery.height * 0.25,
                                child: Center(
                                    // child: Column(
                                    //   children: <Widget>[
                                    //     CircleAvatar(
                                    //       backgroundImage:
                                    //           NetworkImage(loginDataPre[2]),
                                    //       radius: 40,
                                    //       backgroundColor: Colors.transparent,
                                    //     ),
                                    //     Text(
                                    //       loginDataPre[0],
                                    //       style: TextStyle(color: Colors.black45),
                                    //     ),
                                    //     Text(
                                    //       loginDataPre[1],
                                    //       style: TextStyle(color: Colors.black45),
                                    //     ),
                                    //   ],
                                    // ),
                                    ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Container(
                                key: globalKey,
                                width: double.infinity,
                                height: menuContainerHeight,
                                child: Column(
                                  children: <Widget>[
                                    MyButton(
                                      text: "Profile",
                                      iconData: Icons.person,
                                      textSize: getSize(0),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                    MyButton(
                                      text: "Mytask",
                                      iconData: Icons.calendar_today,
                                      textSize: getSize(1),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                    MyButton(
                                      text: "Notifications",
                                      iconData: Icons.notifications,
                                      textSize: getSize(2),
                                      height: (mediaQuery.height / 2) / 5,
                                    ),
                                    MyButton(
                                      text: "Settings",
                                      iconData: Icons.settings,
                                      textSize: getSize(3),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 400),
                          right: (isMenuOpen) ? 10 : sidebarSize,
                          bottom: 30,
                          child: IconButton(
                            enableFeedback: true,
                            icon: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.black45,
                              size: 30,
                            ),
                            onPressed: () {
                              this.setState(() {
                                isMenuOpen = false;
                              });
                            },
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 400),
                          left: (isMenuOpen) ? 10 : sidebarSize,
                          bottom: 30,
                          child: IconButton(
                            enableFeedback: true,
                            icon: Icon(
                              Icons.input,
                              color: Colors.black45,
                              size: 30,
                            ),
                            onPressed: () {
                              ConfirmAlertBox(
                                  title: "Sign Out!",
                                  infoMessage:
                                      "Apakah anda yakin untuk keluar?",
                                  context: context,
                                  onPressedYes: () {
                                    _signOut();
                                  });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signOut() {
    signOutGoogle(loginDataPre[3]);
    logindata.setBool('login', true);
    loginDataPre.clear();
    Navigator.pushNamed(context, LoginScreen.routeName);
  }
}

// @override
// void _signOut() {
//   AlertDialog alertDialog = new AlertDialog(
//     content: Container(
//       height: 215,
//       child: new Column(
//         children: <Widget>[
//           CircleAvatar(
//             backgroundImage: NetworkImage(imageUrl),
//             radius: 30,
//             backgroundColor: Colors.transparent,
//           ),
//           Text(
//             "Log Out?",
//             style: new TextStyle(fontSize: 16.0),
//           )
//         ],
//       ),
//     ),
//   );

//   showDialog(context: null, child: alertDialog);
// }

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;

  MyButton({this.text, this.iconData, this.textSize, this.height});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black45, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {
        if (text == "Log Out") {}
      },
    );
  }
}

class DrawerPainter extends CustomPainter {
  final Offset offset;

  DrawerPainter({this.offset});

  double getControlPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getControlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
