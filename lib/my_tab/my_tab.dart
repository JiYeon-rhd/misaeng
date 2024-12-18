import 'package:flutter/material.dart';
import 'package:misaeng/my_tab/my_add_device.dart';
import 'package:misaeng/my_tab/my_leave_setting.dart';
import 'package:misaeng/my_tab/my_auto_open.dart';
import 'package:misaeng/my_tab/my_subscription_info.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:provider/provider.dart';

class MyTab extends StatefulWidget {
  @override
  _MyTabState createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {
  @override
  void initState() {
    super.initState();
    final selectedDevice =
        Provider.of<SelectedDeviceProvider>(context, listen: false);
    if (selectedDevice.deviceId != null) {
      selectedDevice.fetchDeviceDetails();
    }
  }

  final String userName = "김선하";
  final String userEmail = "beast1422@daum.net";
  //final String deviceName = "misaeng mk-1";
  //final String microbeName = "미생이";
  final String subStartDay = "";
  final String subEndDay = "";
  final String mySubState = "베이직";
  final String servicesDate = "2024. 12. 16 (월)";
  final String servicesTime = "오후 5시 00분";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SelectedDeviceProvider>(
          builder: (context, selectedDevice, child) {
        // Consumer를 통해 가져온 값 출력
        print("[MyTab] Device Name: ${selectedDevice.deviceName ?? 'Unknown'}");
        print(
            "[MyTab] Microbe Name: ${selectedDevice.microbeName ?? 'Unknown'}");

        return Container(
          color: Colors.white, // 배경색 흰색
          child: ListView(
            children: [
              SizedBox(height: 12),
              Row(children: [
                SizedBox(width: 20),
                Image.asset(
                  'images/icon_user.png',
                  width: 25.98,
                  height: 24.47,
                ),
                SizedBox(width: 8),
                _buildText("My", Color(0xFF333333), 20, "LineKrBd"),
              ]),
              SizedBox(height: 40),

              // 프로필 정보
              _buildTextTitle("프로필 정보"),
              SizedBox(height: 12),
              _buildProfileInfo(),
              SizedBox(height: 24),

              // 기기 & 미생물
              _buildTextTitle("기기 & 미생물 정보"),
              SizedBox(height: 20),
              _buildDeviceInfo(context),
              SizedBox(height: 30),

              // 구독 정보
              _buildTextTitle("구독 정보"),
              SizedBox(height: 20),
              _buildSubInfo(context),
              SizedBox(height: 30),

              // 자리 비움 설정
              _buildTextTitle("자리 비움 설정"),
              SizedBox(height: 20),
              _buildLeaveInfo(context),
              SizedBox(height: 30),

              // 문 자동 닫힘 시간 설정
              _buildTextTitle("문 자동 닫힘 시간 설정"),
              SizedBox(height: 20),
              _buildAutoOpen(context),
              SizedBox(height: 30),

              // 점검 방문 | A/S 요청
              _buildTextTitle("점검 방문 | A/S 요청"),
              SizedBox(height: 12),
              _buildServiceInfo(context),
              SizedBox(height: 20),

              // 점검 방문 아래 텍스트 항목들
              _buildTextList("배송지 관리"),
              _buildTextList("내 계좌 관리"),
              _buildTextList("간편결제 관리"),
              _buildTextList("제품 사용 설명서"),
              _buildTextList("자주 묻는 질문"),
              _buildTextList("고객센터"),
              _buildTextList("이용 약관"),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: _buildText("로그아웃", Color(0xFFFF0000), 14, "LineKrRg"),
              ),
            ],
          ),
        );
      }),
    );
  }

  Padding _buildTextTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: _buildText(text, Color(0xFF333333), 16, "LineKrRg"),
    );
  }

  Padding _buildTextList(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 16.0),
      child: _buildText(text, Color(0xFF333333), 16, "LineKrRg"),
    );
  }

  Padding _buildAutoOpen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: _buildBoxDecoration(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 텍스트 색상
            elevation: 0, // 기본 그림자 제거 (Container에서 그림자를 설정)
            padding: EdgeInsets.symmetric(horizontal: 19, vertical: 12),
          ),
          onPressed: () {
            // as 설정 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AutoOpen()),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildText(
                      "자동 닫힘 간격을 설정합니다.", Color(0xFF333333), 12, "LineKrRg"),
                  Row(
                    children: [
                      _buildText("시간 설정", Color(0xFF007AFF), 14, "LineKrRg"),
                      SizedBox(width: 10), // 텍스트와 아이콘 사이 간격
                      Image.asset(
                        'images/icon_arrow_right_gray.png', // 프리미엄 상태 이미지 경로
                        width: 22,
                        height: 22,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildServiceInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: _buildBoxDecoration(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 텍스트 색상
            elevation: 0, // 기본 그림자 제거 (Container에서 그림자를 설정)
            padding: EdgeInsets.symmetric(horizontal: 19, vertical: 12),
          ),
          onPressed: () {
            // as 설정 페이지로 이동
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const AutoOpen()),
            // );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText("정기 방문일", Color(0xFF333333), 12, "LineKrRg"),
                  Row(
                    children: [
                      _buildText(
                          "서비스 요청 및 일정 변경", Color(0xFF007AFF), 14, "LineKrRg"),
                      SizedBox(width: 10), // 텍스트와 아이콘 사이 간격
                      Image.asset(
                        'images/icon_arrow_right_gray.png', // 프리미엄 상태 이미지 경로
                        width: 22,
                        height: 22,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildText("${servicesDate} / ${servicesTime}", Color(0xFF333333),
                  12, "LineKrRg")
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildLeaveInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: _buildBoxDecoration(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 텍스트 색상
            elevation: 0, // 기본 그림자 제거 (Container에서 그림자를 설정)
            padding: EdgeInsets.symmetric(horizontal: 19, vertical: 12),
          ),
          onPressed: () {
            // 자리 비움 설정 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LeaveSetting()),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText("장기간 집을 비울 때 미생물이\n죽지 않도록 영양 캡슐을 투여합니다.",
                      Color(0xFF333333), 12, "LineKrRg"),
                  Row(
                    children: [
                      _buildText("시간 설정", Color(0xFF007AFF), 14, "LineKrRg"),
                      SizedBox(width: 10), // 텍스트와 아이콘 사이 간격
                      Image.asset(
                        'images/icon_arrow_right_gray.png', // 프리미엄 상태 이미지 경로
                        width: 22,
                        height: 22,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 19),
              _buildText("일정시간 문열림이 없는 경우 자동으로 자리 비움 모드가 작동됩니다.",
                  Color(0xFF333333), 10, "LineKrRg"),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSubInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: _buildBoxDecoration(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 텍스트 색상
            elevation: 0, // 기본 그림자 제거 (Container에서 그림자를 설정)
            padding: EdgeInsets.symmetric(horizontal: 19, vertical: 12),
          ),
          onPressed: () {
            // 구독 정보 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MySubscriptionInfo()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildText("구독 기간", Color(0xFF333333), 14, "LineKrRg"),
                    Image.asset(
                      'images/icon_arrow_right_gray.png', // 프리미엄 상태 이미지 경로
                      width: 22,
                      height: 22,
                    )
                  ],
                ),
                SizedBox(height: 5),
                _buildText("${subStartDay} - ${subEndDay}", Color(0xFF333333),
                    14, "LineKrRg"),
                SizedBox(height: 24),
                _buildText("구독 형태", Color(0xFF333333), 14, "LineKrRg"),
                SizedBox(height: 9),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      // 내부에서 다중 자식을 가지려면 Row를 사용
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color(0xFF333333), width: 1.0),
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
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    _buildText(
                      "회원가 할인 & 정기 점검",
                      Color(0xFF333333),
                      12,
                      "LineKrRg",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildDeviceInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<SelectedDeviceProvider>(
          builder: (context, selectedDevice, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 미생물 정보 텍스트
            Container(
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF007AFF)),
                  color: Color.fromARGB(255, 255, 255, 255), // 파란색 배경
                  borderRadius: BorderRadius.circular(22), // 둥근 모서리
                ),
                padding: const EdgeInsets.symmetric(horizontal: 19.0), // 내부 패딩
                alignment: Alignment.center, // 중앙 정렬
                child: _buildText(
                    "${selectedDevice.deviceName ?? '기기 없음'} & ${selectedDevice.microbeName ?? '이름 없음'}",
                    Color(0xFF333333),
                    14,
                    "LineKrRg")),
            SizedBox(width: 11),
            // + 버튼
            Container(
              width: 25,
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(104, 255, 255, 255),
                  shape: CircleBorder(), // 원형 버튼
                  padding: EdgeInsets.zero, // 버튼 크기 조정
                  elevation: 0, // 그림자 효과
                ),
                onPressed: () {
                  // 새 기기 추가 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddDevice()),
                  );
                },
                child: Icon(Icons.add_circle_outline_rounded,
                    color: const Color.fromARGB(113, 51, 51, 51),
                    size: 28), // + 아이콘
              ),
            ),
          ],
        );
      }),
    );
  }

  Padding _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // 외부 여백
      child: Container(
        decoration: _buildBoxDecoration(),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24, // 이미지 크기
            backgroundImage: AssetImage('images/logo_kakao.png'), // 프로필 이미지 경로
            backgroundColor: Colors.transparent, // 배경 제거
          ),
          title: _buildText(userName, Color(0xFF333333), 18, "LineKrRg"),
          subtitle: _buildText(userEmail, Color(0xFF333333), 10, "LineKrRg"),
          trailing: Icon(Icons.more_horiz,
              color: Color.fromARGB(149, 51, 51, 51), size: 21), // 검정 아이콘
        ),
      ),
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
          blurRadius: 1, // 그림자 흐림 정도
          offset: Offset(0, 0), // 그림자 위치 (x, y)
        ),
      ],
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
}
