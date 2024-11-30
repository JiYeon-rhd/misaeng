import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterName extends StatefulWidget {
  final VoidCallback onComplete;
  const RegisterName({required this.onComplete, Key? key}) : super(key: key);

  @override
  _RegisterNameState createState() => _RegisterNameState();
}

class _RegisterNameState extends State<RegisterName> {
  // TextFeild 컨트롤러
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController microbeNameController = TextEditingController();

  // 서버로 데이터 POST 함수
  Future<void> postData() async {
    final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;
    //const url = Uri.parse('$backendUrl/api/auth/kakao'); // 서버 URL
    const serialNum = "9e3f1d9a-8c4a-4b0";
    const deviceType = "mk-1";

    final deviceName = deviceNameController.text;
    final microbeName = microbeNameController.text;

    // 데이터 구성
    final data = {
      "serialNum": serialNum,
      "deviceType": deviceType,
      "deviceName": deviceName,
      "microbeName": microbeName,
    };

    try {
      // POST 요청 보내기
      final response = await http.post(
        Uri.parse('$backendUrl/api/devices/1'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // 요청 성공 처리
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        print("Data posted successfully: ${decodedResponse['message']}");
        widget.onComplete(); // 성공 시 완료 콜백 호출
      } else {
        // 요청 실패 처리
        print("Failed to post data: ${response.statusCode}");
      }
    } catch (e) {
      // 네트워크 오류 처리
      print("Error posting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // 상단 이미지
            SizedBox(height: 50),
            Image.asset(
              'images/icon_misaeng.png', // 이미지 경로
              width: 212,
              height: 212,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 60),
            Text(
              "미생물 처리기의 이름을 설정하세요",
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              style: TextStyle(
                fontSize: 16,
                fontFamily: "LineKrBd",
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),

            // 첫 번째 입력 필드 (기기 이름)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SizedBox(
                height: 50, // 입력 필드 높이
                child: TextField(
                  controller: deviceNameController,
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  decoration: InputDecoration(
                    hintText: '"misaeng mk-1"',
                    hintStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 14,
                      fontFamily: "LineEnBd",
                    ),
                    contentPadding: EdgeInsets.zero, // 내부 여백 제거로 중앙 정렬 유지
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 19),

            Text(
              "미생물의 이름을 지어주세요",
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              style: TextStyle(
                fontSize: 16,
                fontFamily: "LineKrBd",
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),

            // 두 번째 입력 필드 (미생물 이름)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SizedBox(
                height: 50, // 입력 필드 높이
                child: TextField(
                  controller: microbeNameController,
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  decoration: InputDecoration(
                    hintText: '"미생이"',
                    hintStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 14,
                      fontFamily: "LineKrBd",
                    ),
                    contentPadding: EdgeInsets.zero, // 내부 여백 제거로 중앙 정렬 유지
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 7), // 입력 필드와 설명 텍스트 사이 간격
            // 설명 텍스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '미생물의 색은 그냥 처리한 음식에 맞춰 변화합니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 67), // 입력 필드와 설명 텍스트 사이 간격

            // 완료 버튼
            ElevatedButton(
              onPressed: postData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007AFF), // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 10),
              ),
              child: Text(
                '설정 완료',
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
}
