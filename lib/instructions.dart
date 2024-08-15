import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          children: [
            Text(
              "1) Double tap the 'Person Icon' to access the camera to select a profile pciture.",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            Text(
              "2) Long press the 'Person Icon' to select an image from your own gallery.",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            Text(
              "3) You will get a haptic feedback on both of the above cases.",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            Text(
              "4) This app was developed to perfectly fit the dimensions of OnePlus 10T and OnePlus 9 Pro.",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            Text(
              "5) You can press enter from your keyboard after finishing one field to move to the next",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
