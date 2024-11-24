import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CapsuleTab extends StatelessWidget {
  CapsuleTab({super.key});

  // 샘플 데이터: 저장된 캡슐 목록
  final List<Map<String, dynamic>> capsules = [
    {
      'capsuleType': 'MULTI',
      'purchaseDate': '2024.06.07',
      'remain': 4,
    },
    {
      'capsuleType': 'CARBS',
      'purchaseDate': '2024.11.15',
      'remain': 7,
    },
    {
      'capsuleType': 'PROTEIN',
      'purchaseDate': '2024.10.21',
      'remain': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '구독 케어 비활성화',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              //SizedBox(height: 20),
              Container(
                height: 300,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 233, // 슬라이더 높이
                    viewportFraction: 0.85, // 각 카드가 차지하는 비율
                    enlargeCenterPage: true, // 가운데 카드 확대 효과
                    enableInfiniteScroll: false, // 무한 스크롤 여부
                    autoPlay: false, // 자동 재생 여부
                  ),
                  itemCount: capsules.length,
                  itemBuilder: (context, index, realIndex) {
                    return CapsuleCard(
                      capsuleType: capsules[index]['capsuleType'],
                      purchaseDate: capsules[index]['purchaseDate'],
                      remain: capsules[index]['remain'],
                    );
                  },
                ),
              ),
              //SizedBox(height: 20),
              Text(
                '캡슐 관리',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50), // 버튼 크기 지정
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 버튼 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 버튼 모서리 둥글게
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // 버튼 내부 여백
                  elevation: 2, // 버튼 그림자
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '캡슐 구매하러 가기',
                      style: TextStyle(
                        color: Color(0xFF007AFF), // 텍스트 색상
                        fontSize: 16, // 텍스트 크기
                        fontWeight: FontWeight.bold, // 텍스트 굵기
                      ),
                    ),
                    SizedBox(width: 8), // 텍스트와 아이콘 간 간격
                    Icon(Icons.shopping_cart, color: Color(0xFF007AFF)), // 아이콘
                  ],
                ),
              ),

              SizedBox(height: 20),
              Text(
                '최근 투여 일자',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CapsuleHistoryItem(
                      date: '24.06.15', remain: 4, capsuleName: '종합 케어 캡슐'),
                  CapsuleHistoryItem(
                      date: '24.06.13', remain: 7, capsuleName: '탄수화물 캡슐'),
                  CapsuleHistoryItem(
                      date: '24.06.11', remain: 6, capsuleName: '단백질 캡슐'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CapsuleCard extends StatelessWidget {
  final String capsuleType; // 캡슐 타입
  final String purchaseDate;
  final int remain; // 변경된 remain

  const CapsuleCard({
    required this.capsuleType,
    required this.purchaseDate,
    required this.remain,
    super.key,
  });

  // 캡슐 타입에 따라 색상 및 이미지 경로 설정
  Color getColor() {
    switch (capsuleType) {
      case 'MULTI':
        return Colors.blue;
      case 'CARBS':
        return Colors.green;
      case 'PROTEIN':
        return Colors.orange;
      default:
        return Colors.grey; // 기본 색상
    }
  }

  String getImagePath() {
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

  String getTitle() {
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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: getColor(), // 캡슐 타입에 따른 색상
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTitle(), // 캡슐 이름
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    purchaseDate, // 구매 일자
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  // 캡슐 이미지
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 122, // 이미지 높이
                      width: 111, // 이미지 너비
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6), // 모서리 둥글게
                        border:
                            Border.all(color: Colors.white, width: 2), // 흰색 테두리
                        image: DecorationImage(
                          image: AssetImage(getImagePath()), // 캡슐 이미지 경로
                          fit: BoxFit.cover, // 이미지가 잘 채워지도록 설정
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '남은 수량',
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$remain', // 변경된 remain 사용
                              style: TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
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
          left: 70,
          right: 70,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.medication),
            label: Text('캡슐 투여'),
            style: ElevatedButton.styleFrom(
              foregroundColor: getColor(),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}

class CapsuleHistoryItem extends StatelessWidget {
  final String date;
  final int remain;
  final String capsuleName;

  CapsuleHistoryItem({
    required this.date,
    required this.remain,
    required this.capsuleName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4), // 리스트 간 간격
      padding: EdgeInsets.all(5),
      height: 50, // 높이 지정
      decoration: BoxDecoration(
        color: Colors.white, // 각 리스트 아이템의 배경색
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(0, 1), // 그림자 위치
          ),
        ],
      ),
      child: Column(
        children: [
          // 첫 번째 Row: 구매일자
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '$date',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.medication, color: Colors.blue, size: 20),
              SizedBox(width: 8), // 아이콘과 텍스트 간 간격
              Text(
                '$capsuleName',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8), // 캡슐 이름과 남은 수량 간 간격
              Text(
                '$remain/10',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
