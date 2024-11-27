import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

// 자리 비움 설정 페이지
class AutoOpen extends StatefulWidget {
  const AutoOpen({super.key});

  @override
  _AutoOpenState createState() => _AutoOpenState();
}

class _AutoOpenState extends State<AutoOpen> {
  int autoOpenTime = 5; // 활성화 대기 시간 기본 값

  // 문 자동 닫힘 +
  void _incrementAutoOpenTime() {
    if (autoOpenTime < 10) {
      setState(() {
        autoOpenTime++;
      });
    }
  }

  // 문 자동 닫힘 +
  void _decrementAutoOpenTime() {
    if (autoOpenTime > 3) {
      setState(() {
        autoOpenTime--;
      });
    }
  }

  // 저장하기 버튼 후 Dialog 창
  void _saveSettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                "설정 저장 완료",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '문 자동 닫힘 시간 : $autoOpenTime 초',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "문 자동 닫힘 시간 설정"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTimeSetting(
              title: "문 닫힘 대기 시간",
              time: autoOpenTime,
              onIncrement: _incrementAutoOpenTime,
              onDecrement: _decrementAutoOpenTime,
            ),
            const SizedBox(height: 13),
            const Text(
              "상단 문이 열린 후, 다시 닫힐 때까지의 간격을 설정합니다.",
              style: TextStyle(fontFamily: "LineKrRg", fontSize: 13),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007AFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '저장하기',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "LineKrBd",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSetting({
    required String title,
    required int time,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      decoration: _buildBoxDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontFamily: "LineKrRg"),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 시간 표시
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$time',
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: "LineKrRg",
                      letterSpacing: 10.0),
                ),
              ),
              const SizedBox(width: 11),
              const Text(
                '초',
                style: TextStyle(fontFamily: "LindKrRg", fontSize: 16),
              ),
              SizedBox(width: 10),
              // - 버튼
              Container(
                width: 100,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0), // 회색 배경
                  borderRadius: BorderRadius.circular(8), // 둥근 모서리
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // 버튼 간 균등한 간격
                  crossAxisAlignment: CrossAxisAlignment.center, // 수직 중앙 정렬
                  children: [
                    // - 버튼
                    IconButton(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove_rounded),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      iconSize: 20,
                      padding: EdgeInsets.zero, // 기본 패딩 제거
                      constraints: const BoxConstraints(), // 최소 크기 제한 제거
                    ),
                    // 분리 선
                    Container(
                      width: 1, // 선 두께
                      height: 20, // 선 높이
                      color: const Color(0xFFBDBDBD), // 선 색상 (연한 회색)
                    ),
                    // + 버튼
                    IconButton(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add_rounded),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      iconSize: 20,
                      padding: EdgeInsets.zero, // 기본 패딩 제거
                      constraints: const BoxConstraints(), // 최소 크기 제한 제거
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
}
