import 'package:flutter/material.dart';

// 기기 추가 페이지
class AddDevice extends StatelessWidget {
  const AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새 기기 추가"),
      ),
      body: Center(
        child: Text(
          "새로운 기기를 등록하는 페이지입니다.",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}