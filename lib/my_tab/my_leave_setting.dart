import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

// 자리 비움 설정 페이지
class LeaveSetting extends StatefulWidget {
  const LeaveSetting({super.key});

  @override
  _LeaveSettingState createState() => _LeaveSettingState();
}

class _LeaveSettingState extends State<LeaveSetting> {
  int activationTime = 12; // 기본 값 (12시간)

  void _incrementTime() {
    if (activationTime < 24) {
      setState(() {
        activationTime++;
      });
    }
  }

  void _decrementTime() {
    if (activationTime > 1) {
      setState(() {
        activationTime--;
      });
    }
  }

  void _saveActivationTime() {
    // 설정된 값을 디버그 콘솔에 출력
    print("설정된 활성화 대기 시간: $activationTime 시간");
    // 저장 알림 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('활성화 대기 시간 $activationTime 시간으로 저장되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "자리 비움 설정"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            '활성화 대기 시간',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // - 버튼
              IconButton(
                onPressed: _decrementTime,
                icon: const Icon(Icons.remove),
                color: Colors.blueAccent,
                iconSize: 36,
              ),
              // 시간 표시
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$activationTime',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 10),
              const Text('시간',
                  style: TextStyle(fontFamily: "LindKrRg", fontSize: 16)),
              // + 버튼
              IconButton(
                onPressed: _incrementTime,
                icon: const Icon(Icons.add),
                color: Colors.blueAccent,
                iconSize: 36,
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _saveActivationTime,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text(
              '저장',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
