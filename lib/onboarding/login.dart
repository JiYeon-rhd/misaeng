import 'package:flutter/material.dart';
import 'package:misaeng/main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:misaeng/services/backend_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController를 사용하여 입력된 이메일과 비밀번호를 관리합니다.
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 포커스 노드 생성
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  // 힌트 표시 여부
  //bool _isHintVisible = true;

  // 비밀번호 보이기/숨기기 토글용 변수
  bool _obscureText = true;

  // 로그인 버튼 클릭 시 호출될 함수
  void _login() {
    // 여기에서 실제 로그인 로직을 구현합니다.
    // 예를 들어, 서버로 요청을 보내거나 로컬 인증을 수행할 수 있습니다.
    // 로그인 성공 시 메인 앱으로 이동합니다.

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  // 화면 전환을 처리하는 함수
  void _navigateToNextScreen(BuildContext context, String platform) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => NextScreen(platform: platform), // 화면 전환 시 넘길 정보
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to manage focus behavior
    _idFocusNode.addListener(() {
      if (_idFocusNode.hasFocus) {
        _passwordFocusNode.unfocus(); // ID 필드가 활성화되면 비밀번호 필드 비활성화
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _idFocusNode.unfocus(); // 비밀번호 필드가 활성화되면 ID 필드 비활성화
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar를 숨기고 전체 화면을 사용합니다.
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 로고 이미지
              SizedBox(height: 50),
              Image.asset(
                'images/logo_splash.png',
                width: 167,
              ),
              SizedBox(height: 10),

              // welcom ment
              SizedBox(
                width: 170,
                child: Text(
                  "welcome ment",
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  style: TextStyle(
                    fontSize: 16, // 글자 크기
                    letterSpacing: 4.5, // 글자 간격 고정값
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              SizedBox(height: 60),

              // 아이디 입력 필드
              Container(
                width: 191,
                height: 28,
                decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(4)),
                child: TextField(
                  controller: _idController,
                  focusNode: _idFocusNode,
                  textAlign: TextAlign.left,
                  //textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "id",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 166, 166, 166),
                    ),
                    border: InputBorder.none,
                    prefix: SizedBox(width: 12), // 여백 주기
                  ),
                ),
              ),
              SizedBox(height: 12),

              // 비밀번호 입력 필드
              Container(
                width: 191,
                height: 28,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9), // 배경색
                  borderRadius: BorderRadius.circular(4), // 모서리 둥글기
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText, // 비밀번호 숨기기/보이기 설정
                  focusNode: _passwordFocusNode, // 포커스 노드 (ID와 동일)
                  textAlign: TextAlign.left, // 텍스트 수평 중앙 정렬
                  style: TextStyle(
                    color: Colors.black, // 입력 텍스트 색상
                    fontSize: 16, // 입력 텍스트 크기
                  ),
                  decoration: InputDecoration(
                    hintText: "pw", // 힌트 텍스트
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 166, 166, 166), // 힌트 텍스트 색상
                    ),
                    border: InputBorder.none, // 테두리 제거
                    prefix: SizedBox(width: 12), // 여백 주기

                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(right: 8), // 아이콘 여백 조정
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                        color: Color.fromARGB(255, 120, 120, 120), // 아이콘 색상
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // 비밀번호 보이기/숨기기 토글
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // 로그인 버튼
              Center(
                child: SizedBox(
                  width: 191,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD9D9D9), // 배경색 설정
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // 둥근 모서리 (이미지와 동일)
                      ),
                      elevation: 0, // 그림자 제거
                    ),
                    child: Text(
                      'login',
                      style: TextStyle(
                        fontSize: 16, // 텍스트 크기
                        fontWeight: FontWeight.w600,
                        color: Colors.black, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ),

              // 아이디, 비밀번호 찾는 화면으로 이동
              TextButton(
                onPressed: () {
                  // 회원가입 화면으로 이동 (필요에 따라 구현)
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF333333),
                ),
                child: Text(
                  'forgot id/pw?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Create Account
              TextButton(
                onPressed: () {
                  // 계정 생성 화면으로 이동 (필요에 따라 구현)
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF333333),
                ),
                child: Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // 선 추가
              Container(
                width: 191, // 선의 가로 길이 지정
                height: 1, // 선의 두께
                color: Color(0xFFD9D9D9), // 선 색상
              ),
              SizedBox(height: 17),

              Text(
                "or",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.5),

              // 로고 버튼 Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Apple 버튼 (작동하지 않음)
                  Image.asset(
                    'images/logo_apple.png',
                    width: 42,
                    height: 42,
                  ),
                  SizedBox(width: 7.7),

                  // Google 버튼 (작동하지 않음)
                  Image.asset(
                    'images/logo_google.png',
                    width: 42,
                    height: 42,
                  ),
                  SizedBox(width: 7.7),

                  // Naver 버튼 (작동하지 않음)
                  Image.asset(
                    'images/logo_naver.png',
                    width: 42,
                    height: 42,
                  ),
                  //SizedBox(width: 6),

                  // KakaoTalk 버튼 (화면 전환 가능)
                  ElevatedButton(
                    onPressed: () => _loginWithKakao(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // 배경색 제거
                      elevation: 0, // 그림자 제거
                      padding: EdgeInsets.zero, // 여백 제거
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'images/logo_kakao.png', // KakaoTalk 로고 이미지 경로
                          width: 42, // 로고 크기
                          height: 42,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final BackendService _backendService = BackendService();

  // 카카오 로그인 로직
  Future<void> _loginWithKakao(BuildContext context) async {
    try {
      // 1. 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        // 2. 카카오톡으로 로그인
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        // 3. 카카오 계정으로 로그인
        await UserApi.instance.loginWithKakaoAccount();
      }

      // 4. Kakao SDK에서 Access Token 추출
      final token = await TokenManagerProvider.instance.manager.getToken();
      final accessToken = token?.accessToken;

      if (accessToken != null) {
        print('Access Token: $accessToken');

        // 5. Access Token을 백엔드로 전송
        final jwtToken = await _backendService.sendTokenToBackend(accessToken);

        if (jwtToken != null) {
          print('JWT Token: $jwtToken');
          print("로그인 완료");

          // 6. 홈 화면으로 이동
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('Backend Authentication Failed.');
        }
      } else {
        print('Failed to retrieve Kakao Access Token.');
      }
    } catch (e) {
      print('Login Failed: $e');
    }
  }
}
