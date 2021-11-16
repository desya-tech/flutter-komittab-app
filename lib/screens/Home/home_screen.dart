import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:komittab/constants.dart';
import 'package:komittab/model/event.dart';
import 'package:komittab/res/event_firestore_service.dart';
import 'package:komittab/screens/Home/components/add_event.dart';
import 'package:komittab/screens/Login_page/Components/sign_in.dart';
import 'package:komittab/screens/Login_page/Login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:table_calendar/table_calendar.dart';

import 'components/view_event.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/homeScreen";
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences logindata;
  // ignore: non_constant_identifier_names
  List<String> loginDataPre = [];
  int currIndex;
  CalendarController _controller;
  List<dynamic> _selectedEvents;
  // SharedPreferences prefs;
  // ScrollController _scrollController;

  Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventController;

  @override
  void initState() {
    super.initState();
    currIndex = 0;
    _controller = CalendarController();
    // _scrollController = ScrollController();
    _events = {};
    _eventController = TextEditingController();
    _selectedEvents = [];
    initial();
    // initPrefs();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    // if (logindata.getString('email') != 0) {
    setState(() {
      loginDataPre = logindata.getStringList('loginDataPre');
    });

    ListViewPage();
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });

    return data;
  }

  // initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _events = Map<DateTime, List<dynamic>>.from(
  //         decodeMap(jsonDecode(prefs.getString("events") ?? "{}")));
  //   });
  // }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  changePage(int index) {
    setState(() {
      currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (currIndex == 0)
              ? Text("Calender View")
              : (currIndex == 1)
                  ? Text("List View")
                  : (currIndex == 2) ? Text("Setting") : Text("Profil")),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("desya"),
              accountEmail: Text("desya.kristianto"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(loginDataPre[2]),
                radius: 40,
                backgroundColor: Colors.transparent,
              ),
            ),
            new ListTile(
              title: Text("Log Out"),
              trailing: Icon(Icons.input),
              onTap: () {
                ConfirmAlertBox(
                    title: "Sign Out!",
                    infoMessage: "Apakah anda yakin untuk keluar?",
                    context: context,
                    onPressedYes: () {
                      _signOut();
                    });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddEventPage.routeName);
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar:
          // AnimatedBuilder(
          //   animation: _scrollController,
          //   builder: (context, child) {
          //     return AnimatedContainer(
          //       duration: Duration(milliseconds: 300),
          //       height: _scrollController.position.userScrollDirection ==
          //               ScrollDirection.reverse
          //           ? 0
          //           : 50,
          //       child: child,
          //     );
          //   },
          //   child:
          BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        currentIndex: currIndex,
        hasInk: true,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: kPrimaryColor,
            icon: Icon(
              Icons.calendar_today,
              color: Colors.red,
            ),
            activeIcon: Icon(
              Icons.calendar_view_day,
              color: Colors.red,
            ),
            title: Text("Calendar"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.purple,
            icon: Icon(
              Icons.list,
              color: Colors.purple,
            ),
            activeIcon: Icon(
              Icons.view_list,
              color: Colors.purple,
            ),
            title: Text("Task"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.settings_applications,
              color: Colors.black,
            ),
            title: Text("Setting"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(loginDataPre[2]),
              ),
            ),
            activeIcon: Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(loginDataPre[2]),
                radius: 15,
              ),
            ),
            title: Text(loginDataPre[0]),
          ),
        ],
      ),
      // ),
      body: (currIndex == 0)
          ? StreamBuilder<List<EventModel>>(
              stream: eventDBS.streamList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<EventModel> allEvents = snapshot.data;
                  if (allEvents.isNotEmpty) {
                    _events = _groupEvents(allEvents);
                  }
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TableCalendar(
                        events: _events,
                        initialCalendarFormat: CalendarFormat.week,
                        calendarStyle: CalendarStyle(
                            canEventMarkersOverflow: true,
                            todayColor: Colors.orange,
                            selectedColor: Theme.of(context).primaryColor,
                            todayStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white)),
                        headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          formatButtonTextStyle: TextStyle(color: Colors.white),
                          formatButtonShowsNext: false,
                        ),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        onDaySelected: (date, events, holiday) {
                          setState(() {
                            _selectedEvents = events;
                            print("calendar");
                            print(_selectedEvents);
                          });
                        },
                        builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) =>
                              Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                          todayDayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        calendarController: _controller,
                      ),
                      ..._selectedEvents.map((event) => ListTile(
                            title: Text(event.title),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EventDetailsPage(
                                            event: event,
                                          )));
                            },
                          )),
                    ],
                  ),
                );
              })
          : (currIndex == 1)
              ? Container()
              : (currIndex == 2)
                  ? ListViewPage()
                  : Container(
                      child: Text("desya.kristianto"),
                      // width: double.infinity,
                      // child: ListView.builder(
                      //   controller: _scrollController,
                      //   itemBuilder: (context, index) {
                      //     return ListTile(
                      //       title: Text('Google $index'),
                      //       onTap: () {},
                      //     );
                      //   },
                      // ),
                    ),
    );
  }

  void _signOut() {
    signOutGoogle(loginDataPre[3]);
    logindata.setBool('login', true);
    loginDataPre.clear();
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  // addDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: TextField(
  //         controller: _eventController,
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text("Save"),
  //           onPressed: () {
  //             if (_eventController.text.isEmpty) return;
  //             setState(() {
  //               if (_events[_controller.selectedDay] != null) {
  //                 _events[_controller.selectedDay].add(_eventController.text);
  //               } else {
  //                 _events[_controller.selectedDay] = [_eventController.text];
  //               }

  //               prefs.setString("events", json.encode(encodeMap(_events)));
  //               _eventController.clear();
  //               Navigator.pop(context);
  //             });
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}

class ListViewPage extends StatefulWidget {
  ListViewPage({Key key}) : super(key: key);

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("events").snapshots(),
      builder: (context, snapshot) {
        print("datalistview");
        print(snapshot.data);
        if (!snapshot.hasData) {
          Text("Loading....");
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data[index].data["title"]),
                );
              });
        }
      },
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("desya"),
            accountEmail: Text("desya.kristianto"),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
