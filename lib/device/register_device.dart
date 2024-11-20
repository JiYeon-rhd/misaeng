import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:misaeng/bar/top_bar.dart';
import 'package:misaeng/device/register_microbe.dart';

class RegisterDevice extends StatelessWidget {
  late final VoidCallback onComplete;
  RegisterDevice({required this.onComplete});


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
             // NFC 아이콘 (클릭 시 다음 화면으로 이동)
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

            // // RegisterMicrobe으로 넘어가는 임시 버튼 
            // SizedBox(height: 50),
            // ElevatedButton(
            //   onPressed: onComplete,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color.fromARGB(255, 182, 182, 182), // 버튼 색상
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            //   ),
            //   child: Text(
            //     "완료",
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
