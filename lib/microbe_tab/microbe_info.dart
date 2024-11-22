// lib/pages/info_page.dart

import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';


// 미생물 정보 페이지
class MicrobeInfo extends StatelessWidget {
  const MicrobeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "미생물 정보"), // 공통 AppBar
      body: Container(
        child: Text("미생물 정보 페이지"),
      ), 
    );
  }
}
