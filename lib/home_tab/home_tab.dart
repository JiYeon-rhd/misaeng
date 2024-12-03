import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  //const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  //String deviceName = "misaeng 1.0"; // 기기 이름
  //double bday = 1;
  double input = 1.5;
  String state = '분해중';
  //String temperature = '적절';
  //String humid = '높음';
  //String _selectedMode = '일반'; // 기본 선택 모드
  //bool leaveSetting = flase;
  bool _isDialogActive = false; // 다이얼로그 활성 상태 확인

  // 모드 변경 요청 메서드
  Future<void> _updateDeviceMode(String deviceMode) async {
    final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;
    final Uri apiUrl = Uri.parse('$backendUrl/api/devices/state/mode');

    final selectedDeviceProvider =
        Provider.of<SelectedDeviceProvider>(context, listen: false);
    final deviceId = selectedDeviceProvider.deviceId;

    // 모드 변환 함수
    String mapDeviceMode(String mode) {
      switch (mode) {
        case '일반':
          return 'GENERAL';
        case '제습':
          return 'DEHUMID';
        case '절전':
          return 'SAVING';
        default:
          return 'UNKNOWN'; // 기본값 설정
      }
    }
    final mappedMode = mapDeviceMode(deviceMode);
    try {
      final response = await http.put(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'deviceId': deviceId,
          'deviceMode': mappedMode,
        }),
      );

      if (response.statusCode == 200) {
        print('기기 모드 업데이트 성공');
      } else {
        print('기기 모드 업데이트 실패: ${response.statusCode}');
        print('Response Body: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SelectedDeviceProvider>(
          builder: (context, selectedDevice, child) {
        // Consumer를 통해 가져온 값 출력
        print(
            "[HomeTab] Device Name: ${selectedDevice.deviceName ?? 'Unknown'}");
        print("[HomeTab] Microbe Name: ${selectedDevice.bday ?? 'Unknown'}");
        print("[HomeTab] 자리비움: ${selectedDevice.emptyState ?? 'Unknown'}");
        print("[HomeTab] 시리얼넘버: ${selectedDevice.serialNum ?? 'Unknown'}");
        print("[HomeTab] 기기 모드: ${selectedDevice.deviceModeText ?? 'Unknown'}");

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              _buildDeviceName(selectedDevice.deviceName ?? "이름 없음",
                  selectedDevice.bday ?? 999),
              // 기기 상태 섹션
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText("기기 상태", "LineKrRg", 18, Color(0xFF333333)),
                    const SizedBox(height: 13),
                    Container(
                      height: 98,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage(
                              'images/image_home.png'), // 기기 상태 이미지 경로
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusCard('images/home_input.png', '투여량',
                            '${selectedDevice.foodWeightStateText}'),
                        _buildStatusCard('images/home_state.png', '상태',
                            '${selectedDevice.microbeStateSummaryText}'),
                        _buildStatusCard('images/home_temperature.png', '온도',
                            '${selectedDevice.temperatureStateText}'),
                        _buildStatusCard('images/home_humid.png', '습도',
                            '${selectedDevice.humidityStateText}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // 모드 변경 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText('모드 변경', "LineKrRg", 18, Color(0xFF333333)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildModeCard(
                              '일반',
                              '음식물\n쓰레기를\n분해합니다.',
                              selectedDevice.deviceModeText == '일반',
                            ),
                          ),
                          Expanded(
                            child: _buildModeCard(
                              '제습',
                              '내부의\n과도한 습기를\n밖으로\n배출합니다.',
                              selectedDevice.deviceModeText == '제습',
                            ),
                          ),
                          Expanded(
                            child: _buildModeCard(
                              '절전',
                              '전력 사용을\n낮추고\n에너지를\n절약합니다.',
                              selectedDevice.deviceModeText == '절전',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 17),

              // 자리 비움 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // 외부 여백
                child: Consumer<SelectedDeviceProvider>(
                    builder: (context, selectedDevice, child) {
                  bool leaveSetting = selectedDevice.emptyState ?? false;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4), // 내부 여백
                    decoration: BoxDecoration(
                      color: leaveSetting
                          ? Colors.white
                          : const Color(0xFFF0F0F0), // 활성화 여부에 따른 배경색
                      borderRadius: BorderRadius.circular(12), // 둥근 모서리
                      boxShadow: leaveSetting
                          ? [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              )
                            ]
                          : [], // 활성화 상태에 따라 그림자 추가
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '자리 비움',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "LineKrRg",
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.help_outline, // 아이콘
                                color: Color(0xFFB6B6B6),
                                size: 18,
                              ), // 아이콘 버튼
                              onPressed: _showInfoDialog, // 버튼 동작 함수 연결
                            ),
                          ],
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: leaveSetting
                                ? Color(0xFF007AFF)
                                : Colors.transparent, // 활성화 상태에 따른 색상
                            border: Border.all(
                              color: leaveSetting
                                  ? Color(0xFF007AFF)
                                  : Color(0xFFB6B6B6), // 활성화 상태에 따른 테두리 색상
                              width: 1.5,
                            ),
                          ),
                          child: leaveSetting
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : const Icon(
                                  Icons.close,
                                  color: Color(0xFFB6B6B6),
                                  size: 16,
                                ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }

  void _showInfoDialog() {
    if (_isDialogActive) return; // 이미 다이얼로그가 활성화되어 있으면 실행하지 않음

    _isDialogActive = true; // 다이얼로그 활성화 상태로 설정

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 550, // 팝업 위치
        left: MediaQuery.of(context).size.width * 0.13, // 화면 좌측 여백
        right: MediaQuery.of(context).size.width * 0.07, // 화면 우측 여백
        child: Material(
          color: Colors.transparent,
          child: Image.asset(
            'images/home_description.png', // 이미지 경로 (assets 폴더에 있는 이미지)
            fit: BoxFit.contain, // 이미지 크기 조정 방식
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // 일정 시간 후 팝업 제거
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
      _isDialogActive = false; // 다이얼로그 상태를 비활성화로 설정
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

  Row _buildDeviceName(String deviceName, int bday) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          SizedBox(width: 20),
          Image.asset(
            'images/icon_home.png',
            width: 19,
            height: 19,
          ),
          SizedBox(width: 8),
          _buildText(deviceName, "LineKrBd", 20, Color(0xFF333333)),
        ]),
        Row(children: [
          _buildText("D + ${bday}", "LineKrBd", 20, Color(0xFF333333)),
          SizedBox(width: 20),
        ]),
      ],
    );
  }

  Widget _buildStatusCard(String imagePath, String title, String state) {
    final provider =
        Provider.of<SelectedDeviceProvider>(context, listen: false);
    Color statusColor = Color(0xFF007AFF);

    // 음식 투여량
    if (title == "투여량") {
      if (state == "과다") {
        statusColor = Color(0xFFFF0000);
      } else {
        statusColor = Color(0xFF007AFF);
      }
    }
    // 온도, 습도
    if (title == "온도" || title == "습도") {
      if (state == "적절") {
        statusColor = Color(0xFF007AFF);
      } else if (state == "높음") {
        statusColor = Color(0xFFFF0000);
      } else {
        statusColor = Color(0xFFFF0000);
      }
    }

    return Column(
      children: [
        Image.asset(
          imagePath, // 이미지 경로
          width: 50, // 이미지 너비
          height: 50, // 이미지 높이
          color: statusColor,
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontFamily: "LineKrRg",
                color: Color(0xFF333333))),
        const SizedBox(height: 4),
        Text(state,
            style: const TextStyle(
                fontSize: 14,
                fontFamily: "LineKrRg",
                color: Color(0xFF333333))),
      ],
    );
  }

  Widget _buildModeCard(String title, String description, bool isSelected) {
    return Consumer<SelectedDeviceProvider>(
        builder: (context, selectedDevice, child) {
      return GestureDetector(
        onTap: () async {
          setState(() {
            selectedDevice.deviceModeText = title; // 선택된 모드 변경
          });
          await _updateDeviceMode(title);
        },
        child: Container(
          width: 103, // 고정된 너비
          height: 153, // 고정된 높이
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(
            //   color: isSelected ? Colors.blue : Colors.grey,
            //   width: isSelected ? 2 : 1,
            // ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: isSelected ? "LineKrBd" : 'LineKrRg',
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF333333),
                    fontFamily: "LineKrRg"),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFF007AFF)
                          : const Color.fromARGB(126, 158, 158, 158),
                      width: 1,
                    ),
                    color: isSelected ? Color(0xFF007AFF) : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
