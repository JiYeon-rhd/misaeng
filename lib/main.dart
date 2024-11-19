import 'package:flutter/material.dart';
import 'package:misaeng/capsule_tab/capsule_tab.dart';
import 'package:misaeng/home_tab/home_tab.dart';
import 'package:misaeng/microbe_tab/microbe_tab.dart';
import 'package:misaeng/my_tab/my_tab.dart';
import 'package:misaeng/onboarding/login.dart';
import 'package:misaeng/splash_screen.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _TestViewState();
}

void main() => runApp(MaterialApp(
      home: SplashScreen(),
    ));

class _TestViewState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(
        () => setState(() => _selectedIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(51), // AppBar 높이 설정
        child: Container(
          color: Colors.white, // 배경색
          padding: EdgeInsets.only(
              top: 44, left: 21, right: 19.5, bottom: 7), // 여백 설정
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 170,
                height: 32,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/logo_main.png', // 로고 이미지 경로
                        height: 21.76,
                        width: 51,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "MISAENG",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontFamily: 'LineEnBd',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 24,
                width: 80.8,
                child: FittedBox(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 검색 버튼 동작
                        },
                        child: Image.asset(
                          'images/icon_search.png', // 검색 아이콘 이미지 경로
                          width: 16.8, // 이미지 너비
                          height: 16.8, // 이미지 높이
                        ),
                      ),
                      SizedBox(width: 11), // 아이콘 간 간격
                      GestureDetector(
                        onTap: () {
                          // 알림 버튼 동작
                        },
                        child: Image.asset(
                          'images/icon_alarm.png', // 알림 아이콘 이미지 경로
                          width: 16, // 이미지 너비
                          height: 18, // 이미지 높이
                        ),
                      ),
                      SizedBox(width: 11), // 아이콘 간 간격
                      GestureDetector(
                        onTap: () {
                          // 메뉴 버튼 동작
                        },
                        child: Image.asset(
                          'images/icon_hamberger_menu.png', // 메뉴 아이콘 이미지 경로
                          width: 18, // 이미지 너비
                          height: 15, // 이미지 높이
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                _selectedIndex == 0
                    ? Icons.account_balance
                    : Icons.account_balance_outlined,
              ),
              text: "홈",
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 1
                    ? Icons.add_circle
                    : Icons.add_circle_outline,
              ),
              text: "미생물",
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 2 ? Icons.adb_rounded : Icons.adb_rounded,
              ),
              text: "캡슐",
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 3
                    ? Icons.account_circle_rounded
                    : Icons.account_circle_outlined,
              ),
              text: "마이",
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? HomeTab()
          : _selectedIndex == 1
              ? MicrobeTab()
              : _selectedIndex == 2
                  ? CapsuleTab()
                  : MyTab(),
    );
  }
}
