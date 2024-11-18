import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _TestViewState();
}

void main() => runApp(MaterialApp(
  home: MyApp(),
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
    // 불필요한 기능 종료
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
                _selectedIndex == 0 ? Icons.account_balance : Icons.account_balance_outlined,
              ),
              text: "홈",
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 1 ? Icons.add_circle : Icons.add_circle_outline,
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
          ? tabContainer(context, Colors.indigo, "홈 탭")
          : _selectedIndex == 1
          ? tabContainer(context, Colors.amber, "미생물 탭")
          : _selectedIndex == 2
          ? tabContainer(context, Colors.blueGrey, "캡슐 탭")
          : tabContainer(context, Colors.purple, "마이 탭"), // My Tab 처리
    );
  }

  Container tabContainer(BuildContext context, Color tabColor, String tabText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: tabColor,
      child: Center(
        child: Text(
          tabText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
