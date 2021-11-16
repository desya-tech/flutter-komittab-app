import 'package:flutter/material.dart';
import 'package:komittab/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Align(
        alignment: Alignment.bottomCenter,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size.width * 0.945,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 35,
                    color: kPrimaryColor.withOpacity(0.38),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/heart-icon.svg"),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/user-icon.svg"),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/flower.svg"),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            // Scaffold(
            //     bottomNavigationBar: Container(
            //   width: 20,
            //   color: Colors.red,
            // )),
          ],
        ),
      ),
    );
  }
}
