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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // TabController 초기화
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(title: "MISAENG"), // 공통 AppBar
      bottomNavigationBar: TabBar(
        controller: _tabController, // TabController 연결
        indicatorColor: Colors.transparent,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: const <Widget>[
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
      body: TabBarView(
        controller: _tabController, // TabController 연결
        children: [
          HomeTab(),
          MicrobeTab(),
          CapsuleTab(),
          MyTab(),
        ],
      ),
    );
  }
}
