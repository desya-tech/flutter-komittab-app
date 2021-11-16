import 'package:flutter/material.dart';
import 'package:komittab/screens/MyTask/components/buttom_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'header_with_searchBox.dart';

class MyTaskBody extends StatelessWidget {
  const MyTaskBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.055),
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(255, 65, 108, 1.0),
        Color.fromRGBO(255, 75, 73, 1.0)
      ])),
      child: Column(
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          Padding(
            padding: const EdgeInsets.all(64),
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotate,
              color: Colors.white,
            ),
          ),
          BottomBar(size: size),
        ],
      ),
    );
  }
}
