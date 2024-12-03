import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misaeng/bar/top_bar_L2.dart'; // 공통 AppBar
import 'dart:convert'; // JSON 디코딩을 위해 필요
import 'package:http/http.dart' as http;
import 'package:misaeng/home_tab/home_tab.dart';
import 'package:misaeng/main.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:misaeng/register/register_screen.dart';
import 'package:provider/provider.dart'; // http 패키지 import

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;
  List<Map<String, dynamic>> deviceData = []; // 서버에서 가져온 기기와 미생물 정보 저장 리스트
  bool isLoading = true; // 로딩 상태 관리

  int? selectedDeviceId; // 선택된 deviceId
  String? selectedDeviceName; // 선택된 deviceName
  String? selectedMicrobeName; // 선택된 microbeName

  // 서버에서 데이터 가져오기
  Future<void> fetchDeviceData() async {
    final url = Uri.parse('$backendUrl/api/devices/1'); // 1번 사용자 데이터 요청

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 성공적으로 데이터 수신
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print("응답 메시지: ${data['message']}");
        //print("데이터 목록:");

        // 데이터 리스트로 변환
        List<Map<String, dynamic>> fetchedData = [];

        for (var device in data['data']) {
          //print("Device Name: ${device['deviceName']}");
          //print("Microbe Name: ${device['microbeInfo']['microbeName']}");
          fetchedData.add({
            "deviceId": device['deviceId'],
            "serialNum": device['serialNum'],
            "deviceName": device['deviceName'],
            "microbeName": device['microbeInfo']['microbeName'],
            "microbeId": device['microbeInfo']['microbeId'],
            "microbeImage": "images/microbe_bad_blue.png", // 임시 이미지 경로
            "microbeColor": device['microbeInfo']['microbeColor'],
            "microbeMood": device['microbeInfo']['microbeMood'],
          });
          // 상태 업데이트
          setState(() {
            deviceData = fetchedData;
            isLoading = false; // 로딩 상태 해제
          });
        }
      } else {
        // 오류 처리
        print("Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Request failed: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDeviceData(); // 초기화 시 서버 요청
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "기기 & 미생물 정보"), // 공통 AppBar
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중 표시
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2, // 2열
                mainAxisSpacing: 16, // 카드 간 간격
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  ...deviceData.map((data) => DeviceCard(
                        deviceData: data,
                        onTap: () async {
                          // 상태 업데이트
                          await context
                              .read<SelectedDeviceProvider>()
                              .updateDevice(
                                deviceId: data['deviceId'],
                                serialNum: data['serialNum'],
                                microbeId: data['microbeId'],
                              );

                          // 상태 출력
                          context
                              .read<SelectedDeviceProvider>()
                              .printCurrentSelection();

                          // MainApp으로 돌아가기
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainApp()),
                          );
                        },
                      )),
                  AddCard(), // + 카드 추가
                ],
              ),
            ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final Map<String, dynamic> deviceData;
  final VoidCallback onTap;

  const DeviceCard({required this.deviceData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF459EFF), // 그라데이션 시작 색
              Color(0xFF0854A6), // 그라데이션 끝 색
            ],
            begin: Alignment.topLeft, // 그라데이션 시작 위치
            end: Alignment.bottomRight, // 그라데이션 끝 위치
          ),
          borderRadius: BorderRadius.circular(12), // 카드 모서리 둥글게
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "기기 이름",
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: "LineKrRg"),
              ),
              SizedBox(height: 7),
              Text(deviceData['deviceName'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "LineEnBd")),
              SizedBox(height: 14),
              Text(
                "미생물 이름",
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: "LineKrRg"),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      deviceData['microbeName'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  CircleAvatar(
                    radius: 29, // CircleAvatar의 반지름
                    backgroundColor: Colors.white, // CircleAvatar의 배경색
                    child: Stack(
                      alignment: Alignment.center, // 중앙 정렬
                      children: [
                        Image.asset(
                          'images/microbe_shape.png', // 기본 미생물 이미지
                          width: 48, // CircleAvatar 크기에 맞게 조정
                          height: 48,
                          color: getColorFromString(
                              deviceData['microbeColor']), // 전달받은 색상 적용
                        ),
                        Image.asset(
                          deviceData["microbeMood"] == 'BAD'
                              ? 'images/microbe_bad.png' // BAD 상태의 이미지
                              : 'images/microbe_smile.png', // SMILE 상태의 이미지
                          width: 44, // 미생물 이미지 크기 조정
                          height: 44,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 색상 변환 함수
  Color getColorFromString(String colorString) {
    switch (colorString.toUpperCase()) {
      case 'RED':
        return Colors.red;
      case 'ORANGE':
        return Colors.orange;
      case 'YELLOW':
        return Colors.yellow;
      case 'GREEN':
        return Colors.green;
      case 'BLUE':
        return Colors.blue;
      case 'PURPLE':
        return Colors.purple;
      case 'MAGENTA':
        return Colors.pinkAccent; // Flutter에서 Magenta에 가까운 색상
      case 'PINK':
        return Colors.pink;
      case 'BROWN':
        return Colors.brown;
      case 'BLACK':
        return Colors.black;
      case 'WHITE':
        return Colors.white;
      case 'LIME':
        return Colors.lime;
      case 'CYAN':
        return Colors.cyan;
      case 'DARK_BLUE':
        return Colors.blue[900]!; // 진한 파란색
      default:
        return Colors.grey; // 매칭되지 않는 경우 기본 색상
    }
  }
}

class AddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // + 카드 클릭 시 동작
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("기기 추가 페이지로 이동합니다."), duration: Duration(seconds: 1),),
        // );
        // RegisterScreen 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF4F4F4), // 빈 카드 배경색
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            Icons.add_circle_rounded,
            color: Color(0xFF007AFF),
            size: 22,
          ),
        ),
      ),
    );
  }
}
