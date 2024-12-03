import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misaeng/bar/top_bar_L2.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// 자리 비움 설정 페이지
class AutoOpen extends StatefulWidget {
  const AutoOpen({super.key});

  @override
  _AutoOpenState createState() => _AutoOpenState();
}

class _AutoOpenState extends State<AutoOpen> {
  double autoOpenTime = 5.0; // 활성화 대기 시간 기본 값

  Future<void> _updateCapsuleCycle() async {
    final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;
    final Uri apiUrl = Uri.parse('$backendUrl/api/devices/state/close-wait-time');

    final selectedDeviceProvider = Provider.of<SelectedDeviceProvider>(context, listen: false);
    final deviceId = selectedDeviceProvider.deviceId;

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'deviceId': deviceId,
          'closeWaitTime': autoOpenTime, // `double`을 `int`로 변환하여 전송
        }),
      );

      if (response.statusCode == 200) {
        print('문 자동 닫힘 업데이트 성공');
        selectedDeviceProvider.closeWaitTime = autoOpenTime.toDouble(); // 값 업데이트
      } else {
        print('문 자동 닫힘 업데이트 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('네트워크 오류: $e');
    }
  }

    @override
  void initState() {
    super.initState();
    final selectedDeviceProvider =
        Provider.of<SelectedDeviceProvider>(context, listen: false);

    // Device 상태 불러오기
    selectedDeviceProvider.fetchDeviceState().then((_) {
      setState(() {
        // emptyActiveTime 값이 null일 경우 기본값 12로 설정
        autoOpenTime =
            (selectedDeviceProvider.closeWaitTime ?? 5).toDouble();

      });
    });
  }

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
  void _saveSettings() async{
    await _updateCapsuleCycle();
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
                      '문 자동 닫힘 시간 : ${autoOpenTime.toInt()} 초',
                      style: const TextStyle(fontSize: 16,fontFamily: "LineKrRg", color: Color(0xFF333333) ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              const Divider(
                  height: 0.5,
                  color: Color.fromARGB(29, 51, 51, 51)), // Divider 추가
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
    required double time,
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
                  '${time.toInt()}',
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
