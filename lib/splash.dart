import 'dart:async';
import 'package:flutter/material.dart';
import 'package:live_group_chat/services/shared.dart';
import 'package:live_group_chat/view/intro/slider_layout_view.dart';
import 'chat_room.dart';
import 'services/custom_route.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String roomUrl = "";

  @override
  void initState() {
    checkTime();
    super.initState();
  }

  checkTime() async {
    DateTime now = new DateTime.now();
    final String t = now.toString().substring(0,10);

    final String currentTime = await Shared().getCurrentTime();
    final String url = await Shared().getRoomUrl();
    print(url);

    if(t == currentTime) {
      // GO ALREADY CHOOSEN CHAT ROOM
      goChatRoom(url);
    } else {
      // GO GROUPS AND CHOOSE A ROOM
      goGroups();
    }
  }

  goGroups() {
    Timer(Duration(milliseconds: 1500), () {
      Navigator.push(context, createRoute(SliderLayoutView()));
    });
  }

  goChatRoom(String url) {
    Timer(Duration(milliseconds: 1500), () {
      // I WILL PASS THE ROOM URL TO CHAT PAGE
      Navigator.push(context, createRoute(ChatRoom(url: url)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/clock.png", height: MediaQuery.of(context).size.width / 1.8),
            SizedBox(height: 20),
            Text("CHAT", style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.bold
            ),)
          ],
        )
      )
    );
  }
}
