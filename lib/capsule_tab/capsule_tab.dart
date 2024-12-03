import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:provider/provider.dart';

class CapsuleTab extends StatefulWidget {
  CapsuleTab({super.key});
  @override
  _CapsuleTabState createState() => _CapsuleTabState();
}

class _CapsuleTabState extends State<CapsuleTab> {
  bool _isDialogActive = false; // 다이얼로그 활성 상태 확인
  @override
  void initState() {
    super.initState();
    // Provider를 통해 fetchCapsuleDetails 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SelectedDeviceProvider>(context, listen: false)
          .fetchCapsuleDetails();
    });
  }

  // 샘플 데이터: 저장된 캡슐 목록
  final List<Map<String, dynamic>> capsules = [
    {
      'capsuleType': 'MULTI',
      'purchaseDate': '2024.10.03',
      'remain': 10,
    },
    {
      'capsuleType': 'CARBS',
      'purchaseDate': '2024.10.03',
      'remain': 10,
    },
    {
      'capsuleType': 'PROTEIN',
      'purchaseDate': '2024.10.03',
      'remain': 10,
    },
  ];

// 캡슐 수량 감소 로직
  void reduceRemain(SelectedDeviceProvider deviceProvider, BuildContext context,
      String capsuleType) {
    final currentRemain = deviceProvider.capsuleRemainMap[capsuleType];

    if (currentRemain == null) {
      print("캡슐 수량 정보를 가져올 수 없습니다.");
      return;
    }

    if (currentRemain > 0) {
      // 수량이 1 이상이면 -1 감소하고 완료 다이얼로그 표시
      setState(() {
        deviceProvider.capsuleRemainMap[capsuleType] = currentRemain - 1;
      });
      _showCompleteDialog(context);
    } else {
      // 수량이 0이면 구매 다이얼로그 표시, 수량 감소하지 않음
      _showEmptyDialog(context);
    }
  }

  void _showCompleteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(16)), // 상단 테두리 둥글게
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // 배경 흰색
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(16)), // 상단 둥글게
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 내용 크기에 따라 높이 조절
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0), // 패딩 설정
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 24,
                      color: Color(0xFF007AFF), // 아이콘 색상
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "캡슐 투여 완료",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "LineKrBd",
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      "캡슐 투여가 정상적으로 완료되었습니다.",
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
              SizedBox(height: 15),
              const Divider(
                  height: 0.5,
                  color: Color.fromARGB(29, 51, 51, 51)), // Divider 추가
              SizedBox(
                width: double.infinity,
                height: 44, // 버튼 높이
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(), // 모달 닫기
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
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  void _showEmptyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(16)), // 상단 테두리 둥글게
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // 배경 흰색
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(16)), // 상단 둥글게
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 내용 크기에 따라 높이 조절
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0), // 패딩 설정
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 24,
                      color: Color(0xFFFF3B30), // 경고 아이콘 색상
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "캡슐이 모두 소진되었습니다",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "LineKrBd",
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      "새로운 캡슐을 구매해주세요.",
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
              const SizedBox(height: 15),
              const Divider(
                  height: 0.5,
                  color: Color.fromARGB(29, 51, 51, 51)), // Divider 추가
              SizedBox(
                width: double.infinity,
                height: 44, // 버튼 높이
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(), // 모달 닫기
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
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<SelectedDeviceProvider>(context);
    // 캡슐 타입과 남은 수량 출력
    print("캡슐 타입: ${deviceProvider.capsuleType}");
    print("남은 수량: ${deviceProvider.remain}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12), // horizontal: 20
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 캡슐 헤더와 구독 케어 비활성화
              _buildSubInfo(context),
              // 캡슐 카드
              _buildCapsuleCard(deviceProvider),
              // 캡슐 관리 구매 버튼 + 최근 투여 일자
              _build_ManageCapsule(),
            ],
          ),
        ),
      ),
    );
  }

  // 캡슐 헤더 + 비활성화 여부
  Padding _buildSubInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMicrobeName('캡슐'),
          SizedBox(height: 21),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF333333), width: 1.0),
                  borderRadius: BorderRadius.circular(41),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/icon_capsule_none.png',
                      width: 13,
                      height: 13,
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      '구독 케어 비활성화',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "LineKrRg",
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showInfoDialog(context);
                },
                child: Image.asset(
                  'images/icon_sub_info.png',
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 캡슐 헤더
  Row _buildMicrobeName(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Image.asset(
            'images/icon_capsule.png',
            width: 25.98,
            height: 24.47,
          ),
          SizedBox(width: 8),
          _buildText(text, "LineKrBd", 20, Color(0xFF333333)),
        ]),
      ],
    );
  }

// 캡슐 카드 (애니메이션 설정) -> CapsuleCard 클래스로 관리
  Container _buildCapsuleCard(SelectedDeviceProvider deviceProvider) {
    final capsuleRemainMap = deviceProvider.capsuleRemainMap;
    print("if문 전: ${deviceProvider}");

    print("if문 전: ${capsuleRemainMap}");

    // 데이터가 비어 있는 경우 처리
    if (capsuleRemainMap.isEmpty) {
      return Container(
        child: Text(
          '캡슐 데이터를 불러오는 중입니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final capsuleList = capsuleRemainMap.entries.toList();
    return Container(
      height: 300,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 236, // 슬라이더 높이
          viewportFraction: 0.81, // 각 카드가 차지하는 비율
          enlargeCenterPage: true, // 가운데 카드 확대 효과
          enableInfiniteScroll: false, // 무한 스크롤 여부
          autoPlay: false, // 자동 재생 여부
        ),
        itemCount: capsuleList.length,
        itemBuilder: (context, index, realIndex) {
          if (index >= capsuleList.length) {
            return Container(); // 유효하지 않은 인덱스 처리
          }

          // 현재 아이템 가져오기
          final capsuleType = capsuleList[index].key; // 캡슐 타입
          final remain = capsuleList[index].value; // 남은 수량

          return CapsuleCard(
            capsuleType: capsuleType,
            purchaseDate: capsules[index]['purchaseDate'],
            remain: remain.toDouble(),
            onReduceRemain: () =>
                reduceRemain(deviceProvider, context, capsuleType),
            serialNum: deviceProvider.serialNum ?? '',
            capsuleRemainMap: deviceProvider.capsuleRemainMap,
          );
        },
      ),
    );
  }

// 캡슐 관리 구매 버튼 + 최근 투여 일자
  Padding _build_ManageCapsule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '캡슐 관리',
            style: TextStyle(
                fontSize: 18, fontFamily: "LineKrRg", color: Color(0xFF333333)),
          ),
          //SizedBox(height: 11),
          Divider(
              color: Color.fromARGB(197, 217, 217, 217), // 빨간색 구분선
              thickness: 1.0),
          SizedBox(height: 11),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50), // 버튼 크기 지정
              backgroundColor:
                  const Color.fromARGB(255, 255, 255, 255), // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14), // 버튼 모서리 둥글게
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15), // 버튼 내부 여백
              elevation: 1, // 버튼 그림자
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '캡슐 구매하러 가기',
                  style: TextStyle(
                    color: Color(0xFF007AFF), // 텍스트 색상
                    fontSize: 16, // 텍스트 크기
                    fontFamily: "LineKrRg", // 텍스트 굵기
                  ),
                ),
                SizedBox(width: 8), // 텍스트와 아이콘 간 간격
                Image.asset(
                  'images/icon_arrow_right_blue.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildText("최근 투여 일자", "LineKrRg", 16, Color(0xFF333333)),
              _buildText("가장 최근 3번의 기록이 나타압니다.", "LineKrRg", 10,
                  Color.fromARGB(195, 51, 51, 51))
            ],
          ),
          SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // 모서리 둥글게
            child: Container(
              color: Color(0xFFF4F4F4), // 전체 배경색
              child: Consumer<SelectedDeviceProvider>(
                builder: (context, provider, child) {
                  final recentThreeHistory = provider.recentThreeHistory;

                  // 최근 투여 기록이 없을 때
                  if (recentThreeHistory.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "최근 투여 기록이 없습니다.",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "LineKrRg",
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    );
                  }

                  // 최근 투여 기록이 있을 때
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(12.0), // 리스트 전체 패딩
                    itemCount: recentThreeHistory.length,
                    itemBuilder: (context, index) {
                      final item = recentThreeHistory[index];
                      String capsuleName;

                      // 캡슐 타입에 따른 이름 매칭
                      switch (item['capsuleType']) {
                        case 'PROTEIN':
                          capsuleName = '단백질 캡슐';
                          break;
                        case 'MULTI':
                          capsuleName = '종합 케어형';
                          break;
                        case 'CARBS':
                          capsuleName = '탄수화물 캡슐';
                          break;
                        default:
                          capsuleName = '알 수 없는 캡슐';
                      }

                      return Column(
                        children: [
                          _buildCapsuleHistoryItem(
                            date: item['date']?.substring(2) ??
                                '날짜 없음', // 'YYYY-MM-DD'에서 'YY-MM-DD'로 변환
                            capsuleName: capsuleName,
                            iconPath:
                                'images/icon_capsule_info.png', // 공통 아이콘 경로
                          ),
                          if (index < recentThreeHistory.length - 1)
                            SizedBox(height: 8), // 아이템 간 간격
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 최근 투여 일자 리스트 아이템
  Widget _buildCapsuleHistoryItem({
    required String date,
    required String capsuleName,
    required String iconPath,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white, // 카드 배경색
        borderRadius: BorderRadius.circular(6), // 모서리 둥글게
        border: Border.all(
          color: Color(0xFFF2F2F2), // 테두리 색상
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
              fontFamily: "LineKrRg",
            ),
          ),
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8), // 아이콘과 텍스트 간 간격
              Text(
                capsuleName,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: "LineKrRg",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// 구독 서비스 설명 대화창
  void _showInfoDialog(BuildContext context) {
    if (_isDialogActive) return; // 이미 다이얼로그가 활성화되어 있으면 실행하지 않음

    _isDialogActive = true; // 다이얼로그 활성화 상태로 설정

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 185, // 팝업 위치
        left: MediaQuery.of(context).size.width * 0.28, // 화면 좌측 여백
        right: MediaQuery.of(context).size.width * 0.02, // 화면 우측 여백
        child: Material(
          color: Colors.transparent,
          child: Image.asset(
            'images/dialog_capsule.png', // 이미지 경로 (assets 폴더에 있는 이미지)
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
}

// 캡슐 카드 클래스
class CapsuleCard extends StatefulWidget {
  final String capsuleType; // 캡슐 타입
  final String purchaseDate;
  final double remain; // 변경된 remain
  final VoidCallback onReduceRemain;

  final String serialNum; // Device의 serialNum
  final Map<String, int> capsuleRemainMap; // 모든 캡슐의 남은 수량

  const CapsuleCard({
    required this.capsuleType,
    required this.purchaseDate,
    required this.remain,
    required this.onReduceRemain,
    required this.serialNum,
    required this.capsuleRemainMap,
    super.key,
  });
  _CapsuleCardState createState() => _CapsuleCardState();
}

// 캡슐 카드 타입별 설정
class _CapsuleCardState extends State<CapsuleCard> {
  Future<void> sendPostRequest(String capsuleType) async {
    final String backendUrl =
        dotenv.env['FLUTTER_APP_API_URL']!; // Replace with your backend URL
    final Uri apiUrl = Uri.parse('$backendUrl/api/capsules');

    // 캡슐 데이터 구성
    final capsuleList = [
      {
        "capsuleType": capsuleType, // 클릭된 캡슐 타입
        "capsuleCnt": 1, // 감소량은 항상 1로 고정
        "useType": true, // 고정 값
      }
    ];
    // POST 데이터
    final postData = {
      "serialNum": widget.serialNum,
      "capsuleList": capsuleList,
    };

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print("POST 요청 성공: ${response.body}");
      } else {
        print("POST 요청 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("POST 요청 중 오류 발생: $e");
    }
  }

  // 캡슐 타입에 따라 색상 및 이미지 경로 설정
  Color getColor(String capsuleType) {
    switch (capsuleType) {
      case 'MULTI':
        return Color(0xFF007AFF);
      case 'CARBS':
        return Color(0xFF3E98FA);
      case 'PROTEIN':
        return Color(0xFF0854A6);
      default:
        return Colors.grey; // 기본 색상
    }
  }

  String getImagePath(String capsuleType) {
    switch (capsuleType) {
      case 'MULTI':
        return 'images/capsule_multi.png';
      case 'CARBS':
        return 'images/capsule_carbs.png';
      case 'PROTEIN':
        return 'images/capsule_protein.png';
      default:
        return 'images/capsule_multi.png'; // 기본 이미지 경로
    }
  }

  String getTitle(String capsuleType) {
    switch (capsuleType) {
      case 'MULTI':
        return '종합 케어 캡슐';
      case 'CARBS':
        return '탄수화물 캡슐';
      case 'PROTEIN':
        return '단백질 캡슐';
      default:
        return '알 수 없는 캡슐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 버튼이 카드 밖으로 나올 수 있도록 설정
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 19),
          decoration: BoxDecoration(
            color: getColor(widget.capsuleType), // 캡슐 타입에 따른 색상
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getTitle(widget.capsuleType), // 캡슐 이름
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "LineKrBd",
                        color: Colors.white),
                  ),
                  Text(
                    '구매 일자: 2024.10.03', // 구매 일자
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "LineKrRg",
                        fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  // 캡슐 이미지
                  Expanded(
                    flex: 45,
                    child: Container(
                      height: 122, // 이미지 높이
                      width: 111, // 이미지 너비
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                        border:
                            Border.all(color: Colors.white, width: 2), // 흰색 테두리
                        image: DecorationImage(
                          image: AssetImage(
                              getImagePath(widget.capsuleType)), // 캡슐 이미지 경로
                          fit: BoxFit.cover, // 이미지가 잘 채워지도록 설정
                        ),
                      ),
                    ),
                  ),
                  // 남은 수량
                  Expanded(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 19),
                            Text(
                              '남은 수량',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "LineKrBd",
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.remain.toStringAsFixed(0)}', // 변경된 remain 사용
                              style: TextStyle(
                                  fontSize: 45,
                                  fontFamily: "LineKrRg",
                                  color: Colors.white),
                            ),
                            Text(
                              '/10',
                              style:
                                  TextStyle(fontSize: 45, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -25, // 버튼이 카드 아래로 걸치도록 설정
          left: 82,
          right: 82,
          child: ElevatedButton.icon(
            onPressed: () {
              if (widget.remain > 0) {
                // 수량이 0보다 클 때만 POST 요청
                widget.onReduceRemain();
                sendPostRequest(widget.capsuleType);
              }
              else{
                _showEmptyDialog(context);
              }
            },
            icon: Image.asset(
              'images/icon_capsule_info.png', // 이미지 경로
              width: 24, // 이미지 너비
              height: 24,
              color: getColor(widget.capsuleType), // 이미지 높이
              fit: BoxFit.contain, // 이미지 맞춤 설정
            ),
            label: Text(
              '캡슐 투여',
              style: TextStyle(fontFamily: "LineKrBd", fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: getColor(widget.capsuleType),
              backgroundColor: Colors.white, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 둥근 모서리
                side: BorderSide(
                  // 테두리 설정
                  color: getColor(widget.capsuleType), // 테두리 색상
                  width: 1.5, // 테두리 두께
                ),
              ),
              elevation: 0, // 그림자
            ),
          ),
        ),
      ],
    );
  }


  void _showEmptyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(16)), // 상단 테두리 둥글게
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // 배경 흰색
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(16)), // 상단 둥글게
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 내용 크기에 따라 높이 조절
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0), // 패딩 설정
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 24,
                      color: Color(0xFFFF3B30), // 경고 아이콘 색상
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "캡슐이 모두 소진되었습니다",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "LineKrBd",
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      "새로운 캡슐을 구매해주세요.",
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
              const SizedBox(height: 15),
              const Divider(
                  height: 0.5,
                  color: Color.fromARGB(29, 51, 51, 51)), // Divider 추가
              SizedBox(
                width: double.infinity,
                height: 44, // 버튼 높이
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(), // 모달 닫기
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
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
