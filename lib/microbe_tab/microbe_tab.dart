import 'package:flutter/material.dart';

class MicrobeTab extends StatefulWidget {
  const MicrobeTab({super.key});

  @override
  State<MicrobeTab> createState() => _MicrobeTabState();
}

class _MicrobeTabState extends State<MicrobeTab> {
  bool isExpanded = false; // 음식 분해 상태를 펼칠지 여부
  String microbeState = "상태가 좋지 않습니다.."; // 미생이 상태
  double humidity = 80.0; // 습도 (예시 데이터)
  double temperature = 20.0; // 온도 (예시 데이터)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/logo_misaeng.png',
              width: 25.98,
              height: 24.47,
            ),
            SizedBox(width: 8),
            Text(
              "미생이",
              style: TextStyle(
                color: Color(0xFF333333),
                fontFamily: "LineKrBd",
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // 미생이 캐릭터와 말풍선
          _buildMicrobeStatus(),

          // 미생물 상태 요약
          const SizedBox(height: 21),
          _buildMicrobeSummary(),
          const SizedBox(height: 16),
          // 온도/습도 상태 및 음식 분해 상태
          _buildFoodDecompositionStatus(),
          const SizedBox(height: 16),
          // 버튼: 음식물 투입 기록, 미생물 정보
          _buildActionButtons(),
          SizedBox(height: 16),
          const Text(
            '"전용 캡슐로 꼼꼼히 관리해주면 수명이 늘어나요!"',
            style: TextStyle(
              fontFamily: "LineKrRg",
              color: Color(0xFF333333),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // 미생이 캐릭터와 말풍선
  Widget _buildMicrobeStatus() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 캐릭터
        Container(
          width: 270,
          height: 270,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('images/microbe_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Image.asset(
              'images/microbe_bad.png', // 미생이 이미지
              width: 156, // 이미지 크기
              height: 111,
            ),
          ),
        ),
        // 말풍선
        Positioned(
          top: 0,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              "$microbeState",
              style: const TextStyle(fontSize: 12, fontFamily: "LineKrBd"),
            ),
          ),
        ),
      ],
    );
  }

  // 음식 분해 상태
  Widget _buildFoodDecompositionStatus() {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 7),
        width: 335,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6), // 왼쪽 상단 모서리
            topRight: Radius.circular(6), // 오른쪽 상단 모서리
            bottomLeft: Radius.circular(isExpanded ? 12 : 6), // 왼쪽 하단 모서리
            bottomRight: Radius.circular(isExpanded ? 12 : 6), // 오른쪽 하단 모서리
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 7),
                    const Text(
                      "현재 음식을 분해 중입니다.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "LineKrBd"),
                    ),
                  ],
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 7),
            if (isExpanded)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0), // 왼쪽 상단 모서리
                    topRight: Radius.circular(0), // 오른쪽 상단 모서리
                    bottomLeft: Radius.circular(12), // 왼쪽 하단 모서리
                    bottomRight: Radius.circular(12), // 오른쪽 하단 모서리
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 그림자 색
                      spreadRadius: 0, // 그림자 크기
                      blurRadius: 2, // 흐림 정도
                      offset: const Offset(0, 1), // 그림자 위치 (아래로 3px)
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusColumn(
                        "온도", "${temperature.toStringAsFixed(0)}°C"),
                    _buildStatusColumn("습도", "${humidity.toStringAsFixed(0)}%"),
                    _buildStatusColumn("음식 투여량", "없음"),
                    _buildStatusColumn("금지 음식", "없음"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 상태 컬럼 생성
  Widget _buildStatusColumn(String label, String value) {
    return Column(
      children: [
        SizedBox(height: 13),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontFamily: "LineKrRg")),
        SizedBox(height: 11),
        Text(value,
            style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 18,
                fontFamily: "LineKrBd")),
        SizedBox(height: 18),
      ],
    );
  }

  // 액션 버튼
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            "음식물 투입 기록",
            Icons.insert_chart,
            const RecordPage(),
          ),
          _buildActionButton(
            context,
            "미생물 정보",
            Icons.info,
            const InfoPage(),
          ),
        ],
      ),
    );
  }

// 공통 버튼 생성
  Widget _buildActionButton(
      BuildContext context, String label, IconData icon, Widget page) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트를 양 끝에 배치
        crossAxisAlignment: CrossAxisAlignment.center, // 세로로 중앙 정렬
        children: [
          // 텍스트는 오른쪽에 배치
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              fontFamily: "LineKrBd",
            ),
          ),
          // 아이콘을 왼쪽에 배치
          Icon(
            icon,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        // 버튼 크기 지정
        minimumSize: const Size(164, 80), // 최소 크기 (너비 164, 높이 80)
      ),
    );
  }

  // 미생물 상태 요약
  Widget _buildMicrobeSummary() {
    return Column(
      children: [
        // 온도 및 습도 상태
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStatusColumnWithCircle("온도",
                "${temperature.toStringAsFixed(0)}°C", Icons.thermostat, "적절"),
            _buildStatusColumnWithCircle(
                "습도", "${humidity.toStringAsFixed(0)}%", Icons.water, "높음"),
          ],
        ),
      ],
    );
  }

  // 상태 컬럼 생성 + 상태에 따른 동그라미 색상
  Widget _buildStatusColumnWithCircle(
      String label, String value, IconData icon, String status) {
    Color statusColor;

    // 상태에 따라 색상 지정
    if (status == "적절") {
      statusColor = Colors.green;
    } else if (status == "높음") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.grey;
    }

    return Row(
      children: [
        // 아이콘과 텍스트를 세로로 배치
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.black),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF333333), fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
              color: statusColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        // 상태를 나타내는 동그라미
        CircleAvatar(
          radius: 6,
          backgroundColor: statusColor,
        ),
      ],
    );
  }
}

// 음식물 투입 기록 페이지
class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("음식물 투입 기록")),
      body: const Center(child: Text("음식물 투입 기록 페이지")),
    );
  }
}

// 미생물 정보 페이지
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("미생물 정보")),
      body: const Center(child: Text("미생물 정보 페이지")),
    );
  }
}
