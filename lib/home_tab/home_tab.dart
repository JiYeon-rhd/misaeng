import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: Text(
          "홈 탭",
          style: TextStyle(color: const Color.fromARGB(255, 77, 77, 77), fontSize: 24),
        ),
      ),
    );
  }
}
