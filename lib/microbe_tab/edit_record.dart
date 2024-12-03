import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';
import 'package:misaeng/microbe_tab/foodwaste_record.dart';

class EditRecord extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic> record;

  const EditRecord({super.key, required this.date, required this.record});

  @override
  _EditRecordState createState() => _EditRecordState();
}

class _EditRecordState extends State<EditRecord> {
  bool _isBlurred = true; // 초기 상태: 블러 처리된 이미지
  late List<String> selectedCategories;
  bool _isDialogActive = false; // 다이얼로그 활성 상태 확인

  final List<String> forbiddenCategories = [
    '김치 및 절임류',
    '볶음/구이 및 조림류',
    '튀김 및 전/부침류',
    '음식이 아닌 항목'
  ];

  final List<String> notForbiddenCategories = [
    '밥 및 면류',
    '빵 및 곡류',
    '유제품/계란 및 디저트',
    '샐러드 및 과채류',
    '해산물 요리',
    '기타 음식 및 간식',
  ];

  String _getFoodCategoryMessage(String? category) {
    switch (category?.toUpperCase()) {
      case 'KIMCHI':
        return '김치 및 절임류';
      case 'RICE':
        return '밥/주식 및 면류';
      case 'STIR_FRIED':
        return '볶음/구이 및 조림류';
      case 'FRIED':
        return '튀김 및 전/부침류';
      case 'SEAFOOD':
        return '해산물 요리';
      case 'SALAD':
        return '샐러드 및 과채류';
      case 'BREAD':
        return '빵 및 곡류';
      case 'DAIRY':
        return '유제품/계란 및 디저트';
      case 'OTHER':
        return '기타 음식 및 간식';
      case 'NONE_FOOD':
        return '음식이 아닌 항목';
      default:
        return '알 수 없는 카테고리';
    }
  }

  @override
  void initState() {
    super.initState();
    // _getFoodCategoryMessage를 사용하여 변환
    selectedCategories = (widget.record['foodCategory'] as List<dynamic>)
        .map((e) => _getFoodCategoryMessage(e.toString()))
        .toList();

    print("Selected Categories: $selectedCategories");
    print("Not Forbidden Categories: $notForbiddenCategories");
  }

  void _toggleCategory(String category) {
    setState(() {
      selectedCategories.contains(category)
          ? selectedCategories.remove(category)
          : selectedCategories.add(category);
    });
  }

  void _showInfoDialog() {
    if (_isDialogActive) return; // 이미 다이얼로그가 활성화되어 있으면 실행하지 않음

    _isDialogActive = true; // 다이얼로그 활성화 상태로 설정

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 590, // 팝업 위치
        left: MediaQuery.of(context).size.width * 0.13, // 화면 좌측 여백
        right: MediaQuery.of(context).size.width * 0.07, // 화면 우측 여백
        child: Material(
          color: Colors.transparent,
          child: Image.asset(
            'images/dialog_forbidden.png', // 이미지 경로 (assets 폴더에 있는 이미지)
            fit: BoxFit.contain, // 이미지 크기 조정 방식
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // 일정 시간 후 팝업 제거
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
      _isDialogActive = false; // 다이얼로그 상태를 비활성화로 설정
    });
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFFF0000), // 테두리 색상 빨강
                width: 1, // 테두리 두께
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "금지 음식을 주의하세요!",
                  style: TextStyle(
                    color: Color(0xFFFF0000), // 텍스트 색상 빨강
                    fontSize: 16,
                    fontFamily: "LineKrRg",
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.help_outline, // 아이콘
                    color: Color(0xFFFF0000), // 아이콘 색상 빨강
                    size: 20,
                  ), // 아이콘 버튼
                  onPressed: _showInfoDialog, // 버튼 동작 함수 연결
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCategoryButton(String label, bool isSelected) {
    return SizedBox(
      width: 159,
      height: 34,
      child: ElevatedButton(
        onPressed: () => _toggleCategory(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : Color(0xFFF8F8F8),
          foregroundColor: Color(0xFF333333),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: isSelected
              ? BorderSide(color: Colors.grey, width: 1)
              : BorderSide.none,
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "LineKrRg",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Forbidden Categories Section
        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: forbiddenCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 4,
          ),
          itemBuilder: (context, index) {
            final category = forbiddenCategories[index];
            final isSelected = selectedCategories.contains(category.toString());
            return _buildFoodCategoryButton(category, isSelected);
          },
        ),
        //SizedBox(height: 16), // 섹션 간격 추가

        // Not Forbidden Categories Section
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF007AFF), // 테두리 색상 빨강
              width: 1, // 테두리 두께
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "분해 가능한 음식",
                style: TextStyle(
                  color: Color(0xFF007AFF), // 텍스트 색상 빨강
                  fontSize: 16,
                  fontFamily: "LineKrRg",
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notForbiddenCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 4,
          ),
          itemBuilder: (context, index) {
            final category = notForbiddenCategories[index];
            final isSelected = selectedCategories.contains(category.toString());
            return _buildFoodCategoryButton(category, isSelected);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "음식물 분류 수정"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(22), // 전체 패딩
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8), // 회색 배경
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.date.year}년 ${widget.date.month.toString().padLeft(2, '0')}월 ${widget.date.day.toString().padLeft(2, '0')}일',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                                fontFamily: "LineKrRg",
                              ),
                            ),
                            Text(
                              '${widget.record['time']}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontFamily: "LineKrRg"),
                            ),
                          ],
                        ),
                        RichText(
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '투여량\n', // "투여량" 텍스트
                                style: TextStyle(
                                  fontSize: 16, // 기본 크기
                                  color: Color(0xFF333333),
                                  fontFamily: "LineKrRg",
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${widget.record['weight'].toStringAsFixed(1)}', // 무게 값
                                style: TextStyle(
                                  fontSize: 26, // 강조된 크기
                                  color: Color(0xFF333333),
                                  fontFamily: "LineKrRg",
                                ),
                              ),
                              TextSpan(
                                text: ' kg', // "kg" 텍스트
                                style: TextStyle(
                                  fontSize: 26, // 강조된 크기
                                  color: Color(0xFF333333),
                                  fontFamily: "LineKrRg",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30), // 간격 추가
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBlurred = !_isBlurred;
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.record['imgUrl'] ??
                                  'images/foodwaste_image.png',
                              height: 278,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (_isBlurred)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  height: 278,
                                  width: double.infinity,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              _buildInfoRow(),
              SizedBox(height: 16),
              _buildCategoryGrid(),
              //SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // 저장 완료 대화창 표시
                    showDialog(
                      context: context,
                      barrierDismissible: false, // 배경 클릭으로 닫히지 않도록 설정
                      builder: (BuildContext context) =>
                          _buildSaveConfirmationDialog(context),
                    );

                    // 1초 대기 후 대화창 닫기 및 뒤로 가기
                    await Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).pop(); // 대화창 닫기
                      Navigator.of(context).pop(); // 이전 화면으로 이동
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007AFF),
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '저장하기',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "LineKrBd"),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // 저장 완료 대화창 빌드 함수
  Widget _buildSaveConfirmationDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14), // 테두리 둥글게
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 배경색 흰색
          borderRadius: BorderRadius.circular(14), // 테두리 둥글게
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용 크기에 맞춰 다이얼로그 크기 조절
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0), // 패딩 설정
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 26,
                    color: Color(0xFF007AFF), // 아이콘 색상
                  ),
                  SizedBox(height: 12),
                  Text(
                    "저장 완료",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "LineKrBd",
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "선택하신 카테고리가\n성공적으로 저장되었습니다.",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "LineKrRg",
                      color: Color(0xFF333333),
                      height: 1.5, // 줄 간격
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
