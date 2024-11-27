import 'package:flutter/material.dart';
import 'package:misaeng/microbe_tab/foodwaste_record.dart';
import 'package:misaeng/microbe_tab/microbe_info.dart';

class MicrobeTab extends StatefulWidget {
  @override
  State<MicrobeTab> createState() => _MicrobeTabState();
}

class _MicrobeTabState extends State<MicrobeTab> {
  bool isExpanded = false; // 음식 분해 상태를 펼칠지 여부
  String microbeName = "미생이"; // 미생물 별명
  String microbeMessage = "상태가 좋지 않습니다.."; // 미생이 건강 상태
  String microbeMood = "bad"; // 미생이 상태
  Color microbeColor = Color(0xFF007AFF);
  String temperatureStatus = "높음"; // (높음 / 적절 / 낮음 )
  String humidityStatus = "낮음"; // (높음 / 적절 / 낮음 )
  String foodProcessorStatus = "현재 음식을 분해 중 입니다."; // 현재 음식물 처리기 모드
  double humidity = 80.0; // 습도
  double temperature = 20.0; // 온도
  String foodWaste = "과다"; //  음식 투여량 (과다 / 적절)
  String prohibitedFood = "없음"; // 금지 음식 (있음 / 없음)
  String microbeLife = "346"; // 미생물 예측 수명

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            _buildMicrobeName(microbeName),
            const SizedBox(height: 16),
            // 미생이 캐릭터와 말풍선
            _buildMicrobeStatus(),

            // const SizedBox(height: 21),
            // // 음처기 상태 요약
            // _buildFoodProcessorSummary(),

            const SizedBox(height: 26),
            // 음처기 상태 (온도, 습도, 음식 투여량, 금지 음식)
            _buildFoodProcessorStatus(foodProcessorStatus),

            const SizedBox(height: 24),

            // 미생물 예측 수명
            _buildMicrobeLife(),

            const SizedBox(height: 16),
            // 버튼: 음식물 투입 기록, 미생물 정보
            _buildActionButtons(),
            SizedBox(height: 16),

            // 마지막 글자
            _buildText('"전용 캡슐로 꼼꼼히 관리해주면 수명이 늘어나요!"', "LineKrRg", 12,
                Color(0xFF333333))
          ],
        ),
      ),
    );
  }

  Container _buildMicrobeLife() {
    return Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            width: 335,
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildText(
                            "미생물 예측 수명", "LineKrRg", 14, Color(0xFF333333)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildText("${microbeLife}일", "LineEnRg", 16,
                            Color(0xFF333333)),
                        SizedBox(width: 24),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14),
                _buildText('전용 캡슐로 꼼꼼히 관리해주면 수명이 늘어나요!', 'LineKrRg', 12,
                    Color.fromARGB(181, 51, 51, 51))
              ],
            ),
          );
  }

  // 텍스트 위젯
  Widget _buildText(
      String text, String fontfamily, double fontsize, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontfamily,
        fontSize: fontsize,
        color: color,
      ),
    );
  }

  // 미생물 이름과 미생물 교체
  Row _buildMicrobeName(String microbeName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          SizedBox(width: 20),
          Image.asset(
            'images/logo_misaeng.png',
            width: 25.98,
            height: 24.47,
          ),
          SizedBox(width: 8),
          _buildText(microbeName, "LineKrBd", 20, Color(0xFF333333)),
        ]),
        Row(children: [
          Image.asset(
            'images/microbe_change.png',
            width: 22,
            height: 22,
          ),
          SizedBox(width: 4),
          _buildText("미생물 교체", "LineKrRg", 14, Color(0xFF333333)),
          SizedBox(width: 20),
        ]),
      ],
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
            child: Stack(
              alignment: Alignment.center, // 중앙 정렬
              children: [
                Image.asset('images/microbe_shape.png', // 기본 미생이 이미지
                    width: 156,
                    height: 111,
                    color: microbeColor),
                Image.asset(
                  microbeMood == 'bad'
                      ? 'images/microbe_bad.png'
                      : 'images/microbe_smile.png',
                  width: 156,
                  height: 111,
                ),
              ],
            ),
          ),
        ),
        // 말풍선
        Positioned(
          top: 20,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(15),
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
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              "$microbeMessage",
              style: const TextStyle(fontSize: 12, fontFamily: "LineKrRg"),
            ),
          ),
        ),
      ],
    );
  }

  // 미생물 상태 요약
  Widget _buildFoodProcessorSummary() {
    return Column(
      children: [
        // 온도 및 습도 상태
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStatusColumnWithCircle(
                "온도", "images/microbe_temperature.png", temperatureStatus),
            _buildStatusColumnWithCircle(
                "습도", "images/microbe_humidity.png", humidityStatus),
          ],
        ),
      ],
    );
  }

  // 미생물 상태 요약 공통 컬럼
  Widget _buildStatusColumnWithCircle(
      String label, String imagePath, String status) {
    Color statusColor;
    // 상태에 따라 색상 지정
    if (status == "적절") {
      statusColor = Color(0xFF333333);
    } else if (status == "높음") {
      statusColor = Color(0xFFFF0000);
    } else {
      statusColor = Color(0xFF0A42CF);
    }
    return Row(
      children: [
        SizedBox(width: 20),
        // 이미지로 아이콘을 대체
        Image.asset(
          imagePath, // 이미지 경로를 넣습니다
          width: 50, // 이미지 크기 조정
          height: 50, // 이미지 크기 조정
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(label, "LineKrRg", 14, Color(0xFF333333)),
            _buildText(status, "LineKrRg", 18, statusColor),
          ],
        ),
      ],
    );
  }

  // 음처기 정보 토글
  Widget _buildFoodProcessorStatus(String foodProcessorStatus) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
        width: 335,
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildText(
                        foodProcessorStatus, "LineKrRg", 14, Color(0xFF333333)),
                  ],
                ),
                Row(
                  children: [
                    _buildText("D + 1", "LineEnRg", 16, Color(0xFF333333)),
                    SizedBox(width: 9),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Color(0xFF333333),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 11),
            if (isExpanded)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusColumn(
                        "온도", "${temperature.toStringAsFixed(0)}°C"),
                    _buildStatusColumn("습도", "${humidity.toStringAsFixed(0)}%"),
                    _buildStatusColumn("음식 투여량", foodWaste),
                    _buildStatusColumn("금지 음식", prohibitedFood),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 음처기 정보 공통 컬럼 생성
  Widget _buildStatusColumn(String label, String status) {
    Color statusColor = Color(0xFF333333);
    // 음식 투여량, 금지 음식 상태에 따라 색상 지정
    if (label == "음식 투여량" || label == "금지 음식") {
      if (status == "과다" || status == "있음") {
        statusColor = Color(0xFFE4272A);
      } else {
        statusColor = Color(0xFF333333);
      }
    }
    // 온도
    if (label == "온도") {
      if (temperatureStatus == "적절") {
        statusColor = Color(0xFF333333);
      } else if (temperatureStatus == "높음") {
        statusColor = Color(0xFFE4272A);
      } else {
        statusColor = Color(0xFF0A42CF);
      }
    }
    // 습도
    if (label == "습도") {
      if (humidityStatus == "적절") {
        statusColor = Color(0xFF333333);
      } else if (humidityStatus == "높음") {
        statusColor = Color(0xFFE4272A);
      } else {
        statusColor = Color(0xFF0A42CF);
      }
    }

    return Column(
      children: [
        SizedBox(height: 13),
        _buildText(label, "LineKrRg", 14, Color(0xFF333333)),
        SizedBox(height: 11),
        _buildText(status, "LineKrRg", 18, statusColor),
        SizedBox(height: 18),
      ],
    );
  }

  // 음식물 투입 기록, 미생물 정보 페이지 버튼
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            "음식물 투입 기록",
            'images/icon_foodwaste_record.png',
            _navigateToFoodWastePage,
          ),
          _buildActionButton(
            context,
            "미생물 정보",
            'images/icon_microbe_info.png',
            _navigateToInfoPage, // 미생물 정보 버튼 클릭 시 동작
          ),
        ],
      ),
    );
  }

// 버튼 공통 디자인
  Widget _buildActionButton(BuildContext context, String label,
      String imagePath, VoidCallback onPressed) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 80, // 높이 고정
        maxHeight: 80, // 높이 고정
        minWidth: 164,
        //maxWidth: 164,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 둥근 모서리
          ),
          side: BorderSide(
            // 테두리 추가
            color: Color.fromARGB(10, 51, 51, 51), // 테두리 색상
            width: 1.5, // 테두리 두께
          ),
          elevation: 0, // 그림자 제거
          //maximumSize: const Size(164, 80),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 이미지와 텍스트를 양 끝에 배치
          crossAxisAlignment: CrossAxisAlignment.center, // 세로로 중앙 정렬
          children: [
            // 이미지를 왼쪽에 배치
            Image.asset(
              imagePath, // 이미지 경로
              width: 19, // 이미지 너비
              height: 19, // 이미지 높이
            ),
            SizedBox(width: 19), // 이미지와 텍스트 사이 여백
            // 텍스트는 오른쪽에 배치
            _buildText(label, "LineKrRg", 14, Color(0xFF333333)),
          ],
        ),
      ),
    );
  }

  // 음식물 투입 기록 페이지로 이동하는 함수
  void _navigateToFoodWastePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FoodWasteRecord()),
    );
  }

  // 미생물 정보 페이지로 이동하는 함수
  void _navigateToInfoPage() async {
    final selectedColor = await Navigator.push<Color>(
      context,
      MaterialPageRoute(
        builder: (context) => MicrobeInfo(initialColor: microbeColor),
      ),
    );

    if (selectedColor != null) {
      setState(() {
        microbeColor = selectedColor; // 선택된 색상 적용
      });
    }
  }
}
