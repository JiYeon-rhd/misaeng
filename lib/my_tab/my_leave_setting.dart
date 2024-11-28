import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

// 자리 비움 설정 페이지
class LeaveSetting extends StatefulWidget {
  const LeaveSetting({super.key});

  @override
  _LeaveSettingState createState() => _LeaveSettingState();
}

class _LeaveSettingState extends State<LeaveSetting> {
  int activationTime = 12; // 활성화 대기 시간 기본 값
  int capsuleTourTime = 6; // 캡슐 투어 시간 기본 값

  // 활성화 대기 시간 +
  void _incrementActivationTime() {
    if (activationTime < 24) {
      setState(() {
        activationTime++;
      });
    }
  }

  // 활성화 대기 시간 +
  void _decrementActivationTime() {
    if (activationTime > 1) {
      setState(() {
        activationTime--;
      });
    }
  }

  // 캡슐투어 시간 +
  void _incrementCapsuleTourTime() {
    if (capsuleTourTime < 24) {
      setState(() {
        capsuleTourTime++;
      });
    }
  }

  // 캡슐투어 시간 -
  void _decrementCapsuleTourTime() {
    if (capsuleTourTime > 1) {
      setState(() {
        capsuleTourTime--;
      });
    }
  }

  // 저장하기 버튼 후 Dialog 창
  void _saveSettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        child: Container(
          decoration: BoxDecoration(
          color: Colors.white, // 배경색 흰색
          borderRadius: BorderRadius.circular(14), // 테두리 둥글게
        ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0), // 여백 설정
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 24,
                      color: Color(0xFF007AFF), // 아이콘 색상: 파란색
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "저장 완료",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "LineKrBd",
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      '활성화 대기 시간: $activationTime 시간\n캡슐 투어 시간: $capsuleTourTime 시간',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "LineKrRg",
                        color: Color(0xFF333333),
                        height: 1.5, // 줄 간격
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              const Divider(height: 0.5, color: Color.fromARGB(29, 51, 51, 51)), // Divider 추가
              SizedBox(
                width: double.infinity,
                height: 44, // 버튼 높이›ﬁ
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "확인",
                    style: TextStyle(
                      fontSize: 16,
                        fontFamily: "LineKrBd",
                        color: Color(0xFF007AFF),
                    ),
                  ),
                ),
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
      appBar: TopBarL2(title: "자리 비움 설정"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTimeSetting(
              title: "활성화 대기 시간",
              time: activationTime,
              onIncrement: _incrementActivationTime,
              onDecrement: _decrementActivationTime,
            ),
            const SizedBox(height: 13),
            const Text(
              "미생물 상태에 맞춰 자동으로 필요한 캡슐이 투여됩니다.",
              style: TextStyle(fontFamily: "LineKrRg", fontSize: 13),
            ),
            const SizedBox(height: 35),
            _buildTimeSetting(
              title: "캡슐 투어 시간",
              time: capsuleTourTime,
              onIncrement: _incrementCapsuleTourTime,
              onDecrement: _decrementCapsuleTourTime,
            ),
            const SizedBox(height: 13),
            const Text(
              "미생물 상태에 맞춰 자동으로 필요한 캡슐이 투여됩니다.",
              style: TextStyle(fontFamily: "LineKrRg", fontSize: 13),
            ),
            Spacer(),
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
            const SizedBox(height: 138), // 버튼 아래 40픽셀 여백 추가
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
                '시간',
                style: TextStyle(fontFamily: "LindKrRg", fontSize: 16),
              ),
              SizedBox(width: 11),
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
          blurRadius: 1,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
}
