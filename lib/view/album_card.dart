import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final int currentIdx;
  final double currentPage;

  RoomCard({this.currentIdx,this.currentPage});

  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIdx - currentPage;
    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
        ..rotateY(relativePosition),

        alignment: relativePosition >= 0
        ? Alignment.centerLeft
        : Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Image.asset("assets/images/card.png",fit: BoxFit.cover)
        ),
      ),
    );
  }
}