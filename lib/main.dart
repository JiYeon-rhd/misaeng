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
      home: LoginScreen(),
    ));

class _TestViewState extends State<MyApp>
    with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        title: Text("MISAENG"),
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
