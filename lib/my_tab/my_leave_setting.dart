
import 'package:flutter/material.dart';

// 자리 비움 설정 페이지
class LeaveSetting extends StatelessWidget {
  const LeaveSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("자리 비움 설정"),
      ),
      body: Center(
        child: Text(
          "여기서 자리 비움 설정을 관리할 수 있습니다.",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}