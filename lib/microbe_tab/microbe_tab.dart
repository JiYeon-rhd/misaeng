import 'package:flutter/material.dart';

class MicrobeTab extends StatelessWidget {
  const MicrobeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Text(
          "미생물 탭",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
