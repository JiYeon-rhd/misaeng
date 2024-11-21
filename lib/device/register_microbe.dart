import 'package:flutter/material.dart';
import 'package:misaeng/device/register_name.dart';
import 'package:misaeng/main.dart';

class RegisterMicrobe extends StatelessWidget {
  late final VoidCallback onComplete;
  RegisterMicrobe({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Center(
        //padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 설정
        child: Column(

          children: [
            // 상단 이미지
            SizedBox(height: 124),
            Image.asset(
              'images/icon_input_microbe.png', // 이미지 경로
              width: 112.28,
              height: 122,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),

            // 카드 형식 설명
            Container(
              width: 335,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255), // 카드 배경색
                borderRadius: BorderRadius.circular(21),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10), // 카드 내부 여백
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 카드 내부 중앙 정렬
                children: [
                  SizedBox(height: 28),
                  // 첫 번째 설명
                  Text(
                    "1. OPEN/CLOSE 버튼을 눌러 덮개를 열고\n미생물 제재 한 팩(4.5L)을 모두 넣어주세요.",
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 24),

                  // 두 번째 설명
                  Text(
                    "2. 물 500ml를 골고루 부어주시고,\nOPEN/CLOSE 버튼을 눌러 덮개를 닫아주세요.",
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 24),

                  // 세 번째 설명
                  Text(
                    "3. 미생물과 물이 고르게 섞이도록\n약 2시간 기다려주세요.\n이후 약 3일간은 탄수화물, 익힌 음식 위주로\n투입하여 미생물 분해력을 강화해주세요.",
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 28),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 완료 버튼
            ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007AFF), // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              ),
              child: Text(
                "미생물 투입 완료",
                style: TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'LineKrBd'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
