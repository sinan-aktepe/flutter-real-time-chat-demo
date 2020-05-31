import 'package:flutter/material.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {@required this.sliderImageUrl,
      @required this.sliderHeading,
      @required this.sliderSubHeading});
}

final sliderArrayList = [
    Slider(
        sliderImageUrl: 'assets/images/rotate.png',
        sliderHeading: "The Wheel",
        sliderSubHeading: "Pan the wheel and choose a chat room without knowing it"),
    Slider(
        sliderImageUrl: 'assets/images/card.png',
        sliderHeading: "Chat Rooms",
        sliderSubHeading: "Explore different rooms with different topics"),
    Slider(
        sliderImageUrl: 'assets/images/interaction.png',
        sliderHeading: "Fast Messaging",
        sliderSubHeading: "Enjoy real time messaging with new friends"),
    Slider(
        sliderImageUrl: 'assets/images/clock.png',
        sliderHeading: "The Cycle",
        sliderSubHeading: "You will stay in the room you've choosed for a day"),
  ];