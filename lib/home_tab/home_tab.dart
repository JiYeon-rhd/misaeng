import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          "홈 탭",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
