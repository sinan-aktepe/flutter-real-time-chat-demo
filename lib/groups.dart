import 'dart:async';
import 'dart:math';
import 'package:live_group_chat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'chat_room.dart';
import 'services/custom_route.dart';
import 'services/shared.dart';
import 'view/album_card.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.6);

  double currentPage = 0.0;

  bool _isPanning = false;
  String _circleInfo = "Tap to Start";
  Color _circleColor = Colors.white;
  Color _infoColor = Colors.black;

  @override
  void initState() {
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.transparent,
          child: PageView.builder(
            controller: _pageCtrl,
            scrollDirection: Axis.horizontal,
            itemCount: 18,
            itemBuilder: (context, int currentIdx) {
              return RoomCard(
                  currentIdx: currentIdx,
                  currentPage: currentPage);
            },
          ),
        ),
        GestureDetector(
          onPanUpdate: _panHandler,
          onPanStart: _panStart,
          onPanEnd: _panEnd,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
            alignment: Alignment.center,
            height: 220,
            width: 220,
            decoration:
                BoxDecoration(
                  shape: BoxShape.circle,
                  color: _circleColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(85, 115, 255, 1).withOpacity(.08),
                      offset: Offset(.2,.5),
                      blurRadius: 10,
                      spreadRadius: 5
                    )
                  ]),
            child: AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                duration: Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: _isPanning == true
                    ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularText(
                          children: [
                            TextItem(
                              text: Text(
                                "choose and release".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "OpenSans",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              space: 12,
                              startAngle: -90,
                              startAngleAlignment: StartAngleAlignment.center,
                              direction: CircularTextDirection.clockwise,
                            ),
                          ],
                          radius: 125,
                          position: CircularTextPosition.inside,
                          backgroundPaint: Paint()..color = Colors.transparent,
                        ),
                        Image.asset("assets/images/rotate.png",height: 80)
                      ])
                    : Text(_circleInfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _infoColor,
                            fontFamily: "OpenSans",
                            fontSize: 25,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold))),
          ),
        ),
      ]),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    double radius = 150;
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;
    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;
    double rotationalChange =
        (verticalRotation + horizontalRotation) * (d.delta.distance * 0.2);
    _pageCtrl.jumpTo(_pageCtrl.offset + rotationalChange);
  }

  void _panStart(DragStartDetails d) {
    setState(() {
      _isPanning = true;
    });
  }

  void _panEnd(DragEndDetails d) async {
    print("SAYFA : " + _pageCtrl.page.round().toString());
    setState(() {
      _isPanning = false;
      _circleColor = Color.fromRGBO(85, 115, 255, 1);
      _infoColor = Colors.white;
      _circleInfo = "DONE";
    });
    final Random random = new Random();
    var element = random.nextInt(urlList.length);
    DateTime now = new DateTime.now();
    final String t = now.toString().substring(0,10);
    Shared().keepTime("currentTime", t);
    Shared().keepRoom("roomUrl", urlList[element]);
    Timer(Duration(milliseconds: 800), (){
      //Navigator.push(context, createRoute(Deneme(url: urlList[element])));
      Navigator.push(context, createRoute(ChatRoom(url: "")));
    });
  }
}
