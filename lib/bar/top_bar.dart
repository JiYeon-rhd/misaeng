import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // title은 필요에 따라 다르게 표시할 수 있도록 생성자 추가
  const TopBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'images/logo_main.png', // 로고 이미지 경로
            height: 21.76,
            width: 51,
          ),
          SizedBox(width: 8),
          Text(
            title, // 페이지마다 다른 타이틀
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontFamily: 'LineEnBd',
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // 검색 버튼 동작
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'images/icon_search.png', // 검색 아이콘 이미지 경로
              width: 24,
              height: 24,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 알림 버튼 동작
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'images/icon_alarm.png', // 알림 아이콘 이미지 경로
              width: 24,
              height: 24,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 메뉴 버튼 동작
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'images/icon_hamberger_menu.png', // 메뉴 아이콘 이미지 경로
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(51); // AppBar 높이
}
