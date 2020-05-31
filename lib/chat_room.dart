import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:live_group_chat/services/id_generator.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class ChatRoom extends StatefulWidget {
  final String url;
  ChatRoom({this.url});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  SocketIO socketIO;
  List<String> messages;
  List<String> ids;
  List<String> refs;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  var rng = new Random();
  String id;
  String ref = "";
  double _o = 0;

  bool _type = false;

  @override
  void initState() {
    messages = List<String>();
    ids = List<String>();
    refs = List<String>();
    id = IdGenerator().generatePassword(true, true, true, false, 17);
    textController = TextEditingController();
    scrollController = ScrollController();
    socketIO = SocketIOManager().createSocketIO(
      widget.url,
      '/',
    );
    socketIO.init();
    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      setState(() {
        ids.add(data['message']['id']);
        messages.add(data['message']['text']);
        refs.add(data['message']['ref']);
      });
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 800),
        curve: Curves.linear,
      );
    });

    socketIO.subscribe('type', (jsonData) {
      Timer(Duration(milliseconds: 1600), () {
        setState(() {
          _type = false;
        });
      });
      setState(() {
        _type = true;
      });
    });
    socketIO.connect();
    super.initState();
  }

  Widget buildSingleMessage(int index) {
    return Container(
      alignment: ids[index] == id ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(left: 10.0, right: 10),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: ids[index] == id
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  refs[index] == ""
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.3),
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.redAccent,
                                      width: 2,
                                      style: BorderStyle.solid))),
                          child: Text(refs[index],
                              style: TextStyle(fontSize: 10))),
                  InkWell(
                    onLongPress: () {
                      print(messages[index]);
                      setState(() {
                        ref = messages[index];
                        _o = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: ids[index] == id
                            ? Colors.white
                            : Color.fromRGBO(247, 79, 46, 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        messages[index],
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color:
                                ids[index] == id ? Colors.black : Colors.black,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      color: Color(0xffdbe2ef).withOpacity(.5),
      width: width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 150),
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: _type == true
                ? Loading(
                    indicator: BallBeatIndicator(),
                    color: Colors.black,
                    size: 25)
                : Text("Room",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"))),
        body: Stack(children: [
          buildMessageList(),
          Positioned(
            bottom: 50,
            left: 0,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutQuart,
              opacity: _o,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: width, maxWidth: width, maxHeight: 50),
                  child: Container(
                    color: Colors.green.withOpacity(.7),
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text(ref)],
                    )),
                  )),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 60),
                        child: Container(
                          child: TextField(
                            onChanged: (val) {
                              socketIO.sendMessage(
                                  'typing',
                                  json.encode({
                                    'info': {'name': val}
                                  }));
                            },
                            maxLines: null,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Yaz bi şeyler',
                            ),
                            controller: textController,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if (textController.text.isNotEmpty) {
                        socketIO.sendMessage(
                            'send_message',
                            json.encode({
                              'message': {
                                'text': textController.text,
                                'id': id,
                                'ref': ref
                              },
                            }));

                        setState(() {
                          _o = 0;
                          ids.add(id);
                          messages.add(textController.text);
                          refs.add(ref);
                        });
                        textController.text = '';
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.ease,
                        );
                        this.setState(() => ref = "");
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff142850), shape: BoxShape.circle),
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
