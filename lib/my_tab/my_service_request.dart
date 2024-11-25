
import 'package:flutter/material.dart';
// 점검 방문, A/S 요청 페이지
class ServiceRequest extends StatelessWidget {
  const ServiceRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("점검 방문, A/S 요청"),
      ),
      body: Center(
        child: Text(
          "점검 방문 및 A/S 요청을 관리하는 페이지입니다.",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
