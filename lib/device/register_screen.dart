import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar.dart';
import 'package:misaeng/device/register_device.dart';
import 'package:misaeng/device/register_microbe.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "MISAENG"), // 공통 AppBar 사용
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // 페이지 스와이프 비활성화
        children: [
          RegisterDevice(
            onComplete: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          RegisterMicrobe(),
        ],
      ),
    );
  }
}
