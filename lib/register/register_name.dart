import 'package:flutter/material.dart';

class RegisterName extends StatelessWidget {
  final VoidCallback onComplete;
  const RegisterName({required this.onComplete, Key? key}) : super(key: key);
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // 상단 이미지
            SizedBox(height: 50),
            Image.asset(
              'images/icon_misaeng.png', // 이미지 경로
              width: 212,
              height: 212,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 60),
            Text(
              "미생물 처리기의 이름을 설정하세요",
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              style: TextStyle(
                fontSize: 16,
                fontFamily: "LineKrBd",
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),

            // 첫 번째 입력 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SizedBox(
                height: 50, // 입력 필드 높이
                child: TextField(
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  decoration: InputDecoration(
                    hintText: '"misaeng mk-1"',
                    hintStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 14,
                      fontFamily: "LineEnBd",
                    ),
                    contentPadding: EdgeInsets.zero, // 내부 여백 제거로 중앙 정렬 유지
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 19),

            Text(
              "미생물의 이름을 지어주세요",
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              style: TextStyle(
                fontSize: 16,
                fontFamily: "LineKrBd",
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),

            // 두 번째 입력 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SizedBox(
                height: 50, // 입력 필드 높이
                child: TextField(
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  decoration: InputDecoration(
                    hintText: '"미생이"',
                    hintStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 14,
                      fontFamily: "LineKrBd",
                    ),
                    contentPadding: EdgeInsets.zero, // 내부 여백 제거로 중앙 정렬 유지
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 7), // 입력 필드와 설명 텍스트 사이 간격
            // 설명 텍스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '미생물의 색은 그냥 처리한 음식에 맞춰 변화합니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 67), // 입력 필드와 설명 텍스트 사이 간격

            // 완료 버튼
            ElevatedButton(
              onPressed: onComplete, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007AFF), // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 10),
              ),
              child: Text(
                '설정 완료',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "LineKrBd",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
