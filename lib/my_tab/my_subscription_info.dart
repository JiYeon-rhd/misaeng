import 'package:flutter/material.dart';

class MySubscriptionInfo extends StatelessWidget {
  const MySubscriptionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text("구독 정보"),
      ),
      body: Center(
        child: Text(
          "구독 상세 페이지 내용",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}