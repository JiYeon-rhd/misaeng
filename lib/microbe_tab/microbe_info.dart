import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:provider/provider.dart';

class MicrobeInfo extends StatefulWidget {
  final Color initialColor; // 초기 색상을 전달받음
  const MicrobeInfo({super.key, required this.initialColor});

  @override
  State<MicrobeInfo> createState() => _MicrobeInfoState();
}

class _MicrobeInfoState extends State<MicrobeInfo> {
  bool _isColorPickerEnabled = false;
  //Color microbeColor = const Color.fromARGB(255, 40, 147, 255); // 기본 색상
  //String microbeMood = "bad"; // 미생물 상태

  // 미생물이 선택할 수 있는 색상 리스트
  final List<Color> availableColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pinkAccent, // Magenta
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.white,
    Colors.lime,
    Colors.cyan,
    Colors.blue[900]!, // Dark Blue
    Colors.grey, // 기본 색상으로 사용
  ];

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<SelectedDeviceProvider>(context, listen: false);
    Color microbeColor =
        provider.microbeColorRGB ?? Color.fromARGB(255, 40, 147, 255);

    microbeColor = widget.initialColor; // 초기 색상 설정
    _isColorPickerEnabled = availableColors.contains(microbeColor);
  }

  // 동적으로 변경될 날짜 및 D-Day 정보
  //String _microbeName = "미생이";
  //String _microbeDate = "2024년 06월 15일";
  //String _dDay = "D + 1";
  String _averageLifespan = "365일";

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedDeviceProvider>(
        builder: (context, selectedDevice, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBarL2(title: "미생물 정보"), // 공통 AppBar
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 미생물 이미지 표시
                _buildMicrobeCharacter(),
                const SizedBox(height: 20),

                // 미생물 입양 날짜, 수명 표시
                _buildMicrobeLife("${selectedDevice.microbeName}",
                    "${selectedDevice.createdAt}",
                    "D + ${selectedDevice.bday}"),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildText("미생물 꾸미기", "LineKrRg", 16, Color(0xFF333333)),
                    _buildText("미생물의 색은 그날 처리한 음식에 맞춰 변화합니다.", "LineKrRg", 10,
                        Color(0xFF333333))
                  ],
                ),
                SizedBox(height: 9),

                // 색상 선택 토글
                _buildCustomColorToggle(),
                // 색상 선택 UI
                //if (_isColorPickerEnabled) _buildSelectCustomColor(context),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCustomColorToggle() {
    return Consumer<SelectedDeviceProvider>(
        builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8), // 회색 배경
          borderRadius: BorderRadius.circular(14), // 모서리 둥글게
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "색상 직접 고르기",
                  style: TextStyle(fontSize: 14, fontFamily: "LineKrRg"),
                ),
                Switch(
                  value: _isColorPickerEnabled,
                  activeColor: Colors.white, // 토글 ON 상태에서 손잡이 색상 (흰색)
                  activeTrackColor:
                      const Color(0xFF007AFF), // 토글 ON 상태에서 트랙 색상 (파란색)
                  inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255),
                  inactiveTrackColor:
                      const Color(0xFFE0E0E0), // 토글 OFF 상태에서 트랙 색상
                  splashRadius: 0, // 스플래시 효과 제거
                  onChanged: (value) {
                    setState(() {
                      _isColorPickerEnabled = value; // 상태 변경
                    });
                  },
                ),
              ],
            ),
            if (_isColorPickerEnabled) ...[
              const SizedBox(height: 16), // 토글과 색상 선택 간격
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      provider.updateMicrobeColor(color); //  선택한 색상 업데이터
                      _showConfirmationMessage(context, color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: provider.microbeColorRGB == color
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
          ],
        ),
      );
    });
  }

  void _showConfirmationMessage(BuildContext context, Color color) {
    showDialog(
      context: context,
      barrierDismissible: true, // 배경을 클릭해 닫을 수 있도록 설정
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)), // 테두리 둥글게
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // 배경색
              borderRadius: BorderRadius.circular(14), // 테두리 둥글게
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 내용 크기에 맞춰 다이얼로그 크기 조절
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0), // 패딩 설정
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 26,
                        color: Color(0xFF007AFF), // 전달받은 색상을 아이콘 색상에 적용
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "커스텀 색상 적용 완료",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "LineKrBd",
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "선택하신 커스텀 색상이\n정상적으로 적용되었습니다.",
                        style: TextStyle(
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
                const SizedBox(height: 20),
                const Divider(
                  height: 0.5,
                  color: Color.fromARGB(29, 51, 51, 51), // Divider 색상
                ),
                // 확인 버튼 제거, 빈 공간 대신 Divider로 구분만 유지
              ],
            ),
          ),
        );
      },
    );
    // 3초 후에 대화 상자를 닫고 Navigator로 이전 화면으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // AlertDialog 닫기
      //Navigator.pop(context, color); // 이전 화면으로 돌아가기
    });
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

  Column _buildMicrobeLife(
      String microbeName, String microbeDate, String dDay) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(21.0),
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("이름", "LineKrRg", 14, Color(0xFF333333)),
                  Row(
                    children: [
                      _buildText(
                          microbeName, "LineKrRg", 16, Color(0xFF333333)),
                      SizedBox(width: 8),
                      Image.asset(
                        'images/icon_modify.png', // 아이콘 이미지 경로
                        width: 15, // 아이콘 크기
                        height: 15,
                        //color: Colors.grey[600], // 색상 조정 (필요에 따라 제거 가능)
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("입양 날짜", "LineKrRg", 14, Color(0xFF333333)),
                  _buildText(microbeDate, "LineKrRg", 16, Color(0xFF333333)),
                ],
              ),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("함께한 날", "LineKrRg", 14, Color(0xFF333333)),
                  _buildText(dDay, "LineKrRg", 16, Color(0xFF333333)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMicrobeCharacter() {
    //final provider = Provider.of<SelectedDeviceProvider>(context, listen: false);
    //String microbeMood = provider.microbeMood ?? 'SMILE';
    //Color microbeColor = provider.microbeColorRGB ?? Color(0xFF333333);
    return Consumer<SelectedDeviceProvider>(
        builder: (context, provider, child) {
      String microbeMood = provider.microbeMood ?? 'SMILE';
      Color microbeColor = provider.microbeColorRGB ?? Color(0xFF333333);

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
                  microbeMood == 'BAD'
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
    });
  }
}
