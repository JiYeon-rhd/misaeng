import 'package:flutter/material.dart';

class TopBarL2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // title은 필요에 따라 다르게 표시할 수 있도록 생성자 추가
  const TopBarL2({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //SizedBox(width: -100),
          Text(
            title, // 페이지마다 다른 타이틀
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontFamily: 'LineKrBd',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(51); // AppBar 높이
}
