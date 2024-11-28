import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart'; // 공통 AppBar

class AddDevice extends StatelessWidget {
  const AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    // 기기와 미생물 정보 리스트
    final List<Map<String, String>> deviceData = [
      {
        "deviceName": "misaeng mk-1",
        "microbeName": "미생이",
        "microbeImage": "images/microbe_bad_blue.png"
      },
     
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "기기 & 미생물 정보"), // 공통 AppBar
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // 2열
          mainAxisSpacing: 16, // 카드 간 간격
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            ...deviceData.map((data) => DeviceCard(
                  deviceName: data["deviceName"]!,
                  microbeName: data["microbeName"]!,
                  microbeImage: data["microbeImage"]!,
                )),
            AddCard(),
          ],
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String microbeName;
  final String microbeImage;

  const DeviceCard({
    required this.deviceName,
    required this.microbeName,
    required this.microbeImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text(deviceName,
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: "LineEnBd")),
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
                    microbeName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(
                  radius: 29, // CircleAvatar의 반지름
                  backgroundColor: Colors.white, // 원형 배경색
                  child: Padding(
                    padding: const EdgeInsets.all(4.0), // 이미지와 원 사이의 패딩 추가
                    child: ClipOval(
                      child: AspectRatio(
                        aspectRatio: 1, // 정사각형 비율 유지
                        child: Image.asset(
                          microbeImage, // 이미지 파일 경로
                          fit: BoxFit.fitWidth, // 이미지를 적절히 맞춤
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // + 카드 클릭 시 동작
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("기기 추가 페이지로 이동합니다.")),
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
