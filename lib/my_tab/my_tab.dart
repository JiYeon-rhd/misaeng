import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Center(
        child: Text(
          "마이 탭",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
