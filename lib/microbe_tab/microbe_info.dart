import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';
class MicrobeInfo extends StatefulWidget {
  final Color initialColor; // 초기 색상을 전달받음
  const MicrobeInfo({super.key, required this.initialColor});

  @override
  State<MicrobeInfo> createState() => _MicrobeInfoState();
}

class _MicrobeInfoState extends State<MicrobeInfo> {
  bool _isColorPickerEnabled = false;
  Color microbeColor = const Color.fromARGB(255, 40, 147, 255); // 기본 색상
  String microbeMood = "bad"; // 미생물 상태

  // 미생물이 선택할 수 있는 색상 리스트
  final List<Color> availableColors = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.red,
  ];

   @override
  void initState() {
    super.initState();
    microbeColor = widget.initialColor; // 초기 색상 설정
    _isColorPickerEnabled = availableColors.contains(microbeColor);
  }


  // 동적으로 변경될 날짜 및 D-Day 정보
  String _microbeDate = "2024년 06월 15일";
  String _dDay = "D + 1";
  String _averageLifespan = "365일";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "미생물 정보"), // 공통 AppBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 미생물 이미지 표시
            _buildMicrobeCharacter(),
            const SizedBox(height: 20),

            // 미생물 입양 날짜, 수명 표시
            _buildMicrobeLife(),

            const SizedBox(height: 20),

            // 색상 선택 토글
            _buildCustomColorToggle(),
            const SizedBox(height: 20),

            // 색상 선택 UI
            if (_isColorPickerEnabled)
              _buildSelectCustomColor(context),
          ],
        ),
      ),
    );
  }

  Row _buildCustomColorToggle() {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "색상 직접 고르기",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: _isColorPickerEnabled,
                onChanged: (value) {
                  setState(() {
                    _isColorPickerEnabled = value;
                  });
                },
              ),
            ],
          );
  }

  Wrap _buildSelectCustomColor(BuildContext context) {
    return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      microbeColor = color; // 선택한 색상으로 업데이트
                      _isColorPickerEnabled = true; // 색상 지정 토글을 항상 활성화
                    });
                    _showConfirmationMessage(context, color); // 메시지 표시 및 3초 후 이동
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: microbeColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
  }
  void _showConfirmationMessage(BuildContext context, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false, // 배경을 클릭해 닫을 수 없게 설정
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "커스텀 색상이 적용되었습니다.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );

    // 3초 후에 대화 상자를 닫고 Navigator로 이전 화면으로 이동
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // AlertDialog 닫기
      Navigator.pop(context, color); // 이전 화면으로 돌아가기
    });
  }

  Column _buildMicrobeLife() {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "미생물 입양 날짜",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _microbeDate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _dDay,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "미생물 평균 수명",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _averageLifespan,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "전용 캡슐로 꼼꼼히 관리해주면 수명이 늘어나요!",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildMicrobeCharacter() {
    return Center(
      child: Container(
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
            alignment: Alignment.center,
            children: [
              Image.asset(
                'images/microbe_shape.png',
                width: 156,
                height: 111,
                color: microbeColor, // 선택된 색상 반영
              ),
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
    );
  }
}

