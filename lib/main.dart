import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:misaeng/bar/top_bar.dart';
import 'package:misaeng/home_tab/home_tab.dart';
import 'package:misaeng/icon/custom_icons_icons.dart';
import 'package:misaeng/microbe_tab/microbe_tab.dart';
import 'package:misaeng/capsule_tab/capsule_tab.dart';
import 'package:misaeng/my_tab/my_tab.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0; // 현재 선택된 탭 인덱스
  late PageController _pageController; // PageView의 컨트롤러

  final List<Widget> _pages = [
    HomeTab(),
    MicrobeTab(),
    CapsuleTab(),
    MyTab(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabChange(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(title: "MISAENG"), // 공통 AppBar
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 35.0, left: 10.0, right: 10.0, top: 12), // 아래쪽 여백 추가
        child: GNav(
          haptic: true, // haptic feedback
          tabBorderRadius: 40, // 둥근 모서리로 강조
          //curve: Curves.linear, // 자연스러운 애니메이션 곡선
          duration: const Duration(milliseconds: 450), // 애니메이션 지속시간
          gap: 8, // 아이콘과 텍스트 간 간격
          color: Color(0xFF333333)!, // 비활성 아이콘 색상
          activeColor: const Color.fromARGB(255, 255, 255, 255), // 활성 아이콘 및 텍스트 색상
          iconSize: 30, // 아이콘 크기
          tabBackgroundColor: Color.fromARGB(233, 0, 123, 255), // 활성 탭 배경색
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9), // 활성 탭 패딩
          selectedIndex: _selectedIndex,
          tabs: const [
            GButton(
              icon: CustomIcons.navi_home,
              text: 'Home',
              textStyle: const TextStyle(fontSize: 14, fontFamily: "LineEnBd", color: Colors.white), // 글꼴과 크기
            ),
            GButton(
              icon: CustomIcons.navi_microbe,
              text: 'Microbe',
              textStyle: const TextStyle(fontSize: 14, fontFamily: "LineEnBd", color: Colors.white),
            ),
            GButton(
              icon: CustomIcons.navi_capsule,
              text: 'Capsule',
              textStyle: const TextStyle(fontSize: 14, fontFamily: "LineEnBd", color: Colors.white),
            ),
            GButton(
              icon: CustomIcons.navi_my,
              text: 'My',
              textStyle: const TextStyle(fontSize: 14, fontFamily: "LineEnBd", color: Colors.white),
            ),
          ],
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}
