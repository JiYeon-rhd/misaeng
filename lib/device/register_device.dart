import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:misaeng/device/register_microbe.dart';

class RegisterDevice extends StatelessWidget {
  late final VoidCallback onComplete;
  RegisterDevice({super.key, required this.onComplete});

  static const spinkit = SpinKitRipple(
    color: Color(0xFF858585),
    size: 40.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 화면 디자인
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 124),

            GestureDetector(
              onTap: onComplete, // NFC 아이콘을 눌렀을 때 onComplete 실행
              child: Image.asset(
                'images/icon_nfc.png',
                width: 112.28,
                height: 122,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 44),

            // 설명 텍스트
            Text(
              "스마트폰을 제품 상단부에\n5초간 가져다 대주세요",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                  fontFamily: 'LineKrBd'),
            ),
            SizedBox(height: 30),
            Text(
              "연결이 되지 않을 시,\n스마트폰을 위아래로 천천히 움직여주세요.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                fontFamily: 'LineKrRg',
              ),
            ),

            SizedBox(height: 25),

            // 로딩 아이콘
            spinkit,

          ],
        ),
      ),
    );
  }
}
