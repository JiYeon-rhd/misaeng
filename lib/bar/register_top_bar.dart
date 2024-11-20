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
      //Image:Image.asset(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(51); // AppBar 높이
}
