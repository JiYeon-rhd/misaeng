import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:misaeng/bar/top_bar.dart';
import 'package:misaeng/home_tab/home_tab.dart';
import 'package:misaeng/icon/custom_icons_icons.dart';
import 'package:misaeng/microbe_tab/microbe_tab.dart';
import 'package:misaeng/capsule_tab/capsule_tab.dart';
import 'package:misaeng/my_tab/my_add_device.dart';
import 'package:misaeng/my_tab/my_tab.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misaeng/onboarding/login.dart';
import 'package:misaeng/onboarding/splash_screen.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:misaeng/register/register_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await initializeDateFormatting(); // 날짜/시간 로케일 초기화
  await dotenv.load(fileName: ".env"); // .env 파일 로드

  KakaoSdk.init(
    nativeAppKey: dotenv.env['FLUTTER_NATIVE_APP_KEY']!,
    javaScriptAppKey: dotenv.env['FLUTTER_APP_JAVASCRIPT_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SelectedDeviceProvider()), // Provider 등록
      ],
      // child: MaterialApp(
      //   initialRoute: '/',
      //   routes: {
      //     '/': (context) => SplashScreen(),
      //     '/home': (context) => RegisterScreen(),
      //   },
      // ),
      child: MaterialApp(
          //title: 'Misaeng App',
          home: AddDevice(), // 첫 화면을 SplashScreen으로 설정
        ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    try {
      String? token = await _storage.read(key: 'jwtToken');
      return token;
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // 로그인 상태 확인
        bool isLoggedIn = false;

        // return MaterialApp(
        //   title: 'Misaeng App',
        //   initialRoute: isLoggedIn ? '/home' : '/',
        //   routes: {
        //     '/': (context) => SplashScreen(),
        //     '/home': (context) => MainApp(),
        //   },
        // );
        return MaterialApp(
          title: 'Misaeng App',
          home: AddDevice(), // 첫 화면을 SplashScreen으로 설정
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0; // 현재 선택된 탭 인덱스
  late PageController _pageController; // PageView의 컨트롤러

  final List<Widget> _pages = [
    HomeTab(),
    MicrobeTab(),
    CapsuleTab(),
    MyTab(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabChange(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(title: "MISAENG"), // 공통 AppBar
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            bottom: 35.0, left: 10.0, right: 10.0, top: 12), // 아래쪽 여백 추가
        child: GNav(
          haptic: true, // haptic feedback
          tabBorderRadius: 40, // 둥근 모서리로 강조
          //curve: Curves.linear, // 자연스러운 애니메이션 곡선
          duration: const Duration(milliseconds: 450), // 애니메이션 지속시간
          gap: 8, // 아이콘과 텍스트 간 간격
          color: Color(0xFF333333)!, // 비활성 아이콘 색상
          activeColor:
              const Color.fromARGB(255, 255, 255, 255), // 활성 아이콘 및 텍스트 색상
          iconSize: 30, // 아이콘 크기
          tabBackgroundColor: Color.fromARGB(233, 0, 123, 255), // 활성 탭 배경색
          padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 9), // 활성 탭 패딩
          selectedIndex: _selectedIndex,
          tabs: const [
            GButton(
              icon: CustomIcons.navi_home,
              text: '홈',
              textStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: "LineKrBd",
                  color: Colors.white), // 글꼴과 크기
            ),
            GButton(
              icon: CustomIcons.navi_microbe,
              text: '미생물',
              textStyle: const TextStyle(
                  fontSize: 14, fontFamily: "LineKrBd", color: Colors.white),
            ),
            GButton(
              icon: CustomIcons.navi_capsule,
              text: '캡슐',
              textStyle: const TextStyle(
                  fontSize: 14, fontFamily: "LineKrBd", color: Colors.white),
            ),
            GButton(
              icon: CustomIcons.navi_my,
              text: 'My',
              textStyle: const TextStyle(
                  fontSize: 14, fontFamily: "LineEnBd", color: Colors.white),
            ),
          ],
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}
