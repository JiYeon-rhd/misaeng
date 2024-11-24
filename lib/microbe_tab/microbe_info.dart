import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

class MicrobeInfo extends StatefulWidget {
  const MicrobeInfo({super.key});

  @override
  State<MicrobeInfo> createState() => _MicrobeInfoState();
}

class _MicrobeInfoState extends State<MicrobeInfo> {
  Color _selectedColor = Colors.blue;
  bool _isColorPickerEnabled = false;

  // 색상에 따른 이미지 경로
  final Map<Color, String> _microbeImages = {
    Colors.blue: 'images/microbe_bad_blue.png',
    Colors.yellow: 'images/microbe_good_yellow.png',
  };

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
            Center(
              child: Image.asset(
                _microbeImages[_selectedColor] ?? 'images/microbe_bad_blue.png',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 20),

            // 미생물 정보 표시 (날짜, D-Day)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "미생물 입양 날짜" 텍스트를 회색 박스 외부로 분리
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
                      // "미생물 평균 수명" Row로 변경
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
            ),

            const SizedBox(height: 20),

            // 색상 선택 토글
            Row(
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
            ),
            const SizedBox(height: 20),

            // 색상 선택 UI
            if (_isColorPickerEnabled)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _microbeImages.keys.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
