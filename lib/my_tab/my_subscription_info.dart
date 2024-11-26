import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

class MySubscriptionInfo extends StatelessWidget {
  const MySubscriptionInfo({super.key});

  final String subStartDay = "2024.06.07";
  final String subEndDay = "2025.06.06";
  final String mySubState = "베이직";
  final double subscriptionDate = 352;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "구독 정보"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        children: [
          // 구독 기간 섹션
          _buildSubInfo(),
          SizedBox(height: 20),

          // 구독 남은 기간 text
          _buildSubDate(),
          SizedBox(height: 18),

          // 구독 종류 설명
          Container(
            padding: const EdgeInsets.all(19.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildText("구독 종류", Color(0xFF333333), 14, "LineKrRg"),
                  ],
                ),
                SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'images/icon_premium.png', // 프리미엄 상태 이미지 경로
                          width: 32,
                          height: 32,
                        ),
                        SizedBox(width: 10),
                        _buildText(
                            "프리미엄 케어", Color(0xFF333333), 14, "LineKrRg"),
                      ],
                    ),
                    SizedBox(width: 35),
                    _buildText(
                        "회원가 할인 & 정기 점검", Color(0xFF333333), 14, "LineKrRg")
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'images/icon_standard.png', // 프리미엄 상태 이미지 경로
                          width: 32,
                          height: 32,
                        ),
                        SizedBox(width: 10),
                        _buildText(
                            "스탠다드 케어", Color(0xFF333333), 14, "LineKrRg"),
                      ],
                    ),
                    SizedBox(width: 35),
                    _buildText(
                        "전문 A/S 기사 정기 방문", Color(0xFF333333), 14, "LineKrRg")
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'images/icon_basic.png', // 프리미엄 상태 이미지 경로
                          width: 32,
                          height: 32,
                        ),
                        SizedBox(width: 10),
                        _buildText("베이직 케어", Color(0xFF333333), 14, "LineKrRg"),
                      ],
                    ),
                    SizedBox(width: 35),
                    _buildText(
                        "캡슐 회원가 할인 & 배송", Color(0xFF333333), 14, "LineKrRg")
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildSubDate() {
    return Row(
      children: [
        SizedBox(width: 5),
        Text.rich(
          TextSpan(
            text: "구독 종료까지 앞으로 ",
            style: TextStyle(fontSize: 16, fontFamily: "LineKrBd"),
            children: [
              TextSpan(
                text: "${subscriptionDate.toInt()}",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "LineKrBd",
                  color: Color(0xFF007AFF), // 색상 변경
                ),
              ),
              TextSpan(
                text: "일 남았어요.",
                style: TextStyle(fontSize: 16, fontFamily: "LineKrBd"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildSubInfo() {
    return Container(
      decoration: _buildBoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildText("구독 기간", Color(0xFF333333), 14, "LineKrRg"),
          SizedBox(height: 5),
          _buildText("${subStartDay} ~ ${subEndDay}", Color(0xFF333333), 14,
              "LineKrBd"),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // 내부에서 다중 자식을 가지려면 Row를 사용
                children: [
                  _buildIconForSubState(mySubState), // 상태에 따른 아이콘 선택
                  SizedBox(width: 8),
                  _buildText(
                    "${mySubState} 케어",
                    Color(0xFF333333),
                    14,
                    "LineKrBd",
                  ),
                ],
              ),
              SizedBox(width: 8),
              _buildText(
                "회원가 할인 & 정기 점검",
                Color(0xFF333333),
                14,
                "LineKrRg",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text _buildText(
      String text, Color color, double fontsize, String fontfamily) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontSize: fontsize, fontFamily: fontfamily),
    );
  }

  Widget _buildIconForSubState(String subState) {
    switch (subState) {
      case '프리미엄':
        return Image.asset(
          'images/icon_premium.png', // 프리미엄 상태 이미지 경로
          width: 32,
          height: 32,
        );
      case '스탠다드':
        return Image.asset(
          'images/icon_standard.png', // 스탠다드 상태 이미지 경로
          width: 32,
          height: 32,
        );
      case '베이직':
        return Image.asset(
          'images/icon_basic.png', // 베이직 상태 이미지 경로
          width: 32,
          height: 32,
        );
      default:
        return Image.asset(
          'images/icon_basic.png', // 기본값 이미지 경로
          width: 32,
          height: 32,
        );
    }
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white, // 버튼 배경색
      borderRadius: BorderRadius.circular(14), // 둥근 모서리
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // 그림자 색상 (반투명 회색)
          spreadRadius: 0, // 그림자 확산 정도
          blurRadius: 2, // 그림자 흐림 정도
          offset: Offset(0, 0), // 그림자 위치 (x, y)
        ),
      ],
    );
  }
}
