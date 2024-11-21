import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar.dart';
import 'package:misaeng/home_tab/home_tab.dart';
import 'package:misaeng/microbe_tab/microbe_tab.dart';
import 'package:misaeng/capsule_tab/capsule_tab.dart';
import 'package:misaeng/my_tab/my_tab.dart';

void main() => runApp(
      const MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false, // 디버그 배너 제거
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 탭의 개수
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(title: "MISAENG"), // 공통 AppBar
        bottomNavigationBar: const TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.account_balance_outlined),
              text: "홈",
            ),
            Tab(
              icon: Icon(Icons.add_circle_outline),
              text: "미생물",
            ),
            Tab(
              icon: Icon(Icons.adb_rounded),
              text: "캡슐",
            ),
            Tab(
              icon: Icon(Icons.account_circle_outlined),
              text: "마이",
            ),
          ],
        ),
        body: const TabBarView(
          children: <Widget>[
            HomeTab(),
            MicrobeTab(),
            CapsuleTab(),
            MyTab(),
          ],
        ),
      ),
    );
  }
}
