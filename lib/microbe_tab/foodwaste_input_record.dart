// lib/pages/record_page.dart

import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

// 음식물 투입 기록 페이지
class FoodWasteInputRecord extends StatelessWidget {
  const FoodWasteInputRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: TopBarL2(title: "음식물 투입 기록"), // 공통 AppBar
      body:  Text("음식물 투입 기록"),

    );
  }
}