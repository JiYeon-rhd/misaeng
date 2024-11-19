import 'package:flutter/material.dart';

class CapsuleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Text(
          "캡슐 탭",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
