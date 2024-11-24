import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:misaeng/bar/top_bar_L2.dart';

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

  final List<String> allCategories = [
    '김치 및 절임류',
    '과일류',
    '밥 및 면류',
    '빵 및 곡류',
    '볶음/구이 및 조림류',
    '유제품/계란 및 디저트',
    '튀김 및 전/부침류',
    '샐러드 및 채소류',
    '해산물 요리',
    '기타 음식 및 간식',
  ];

  @override
  void initState() {
    super.initState();
    selectedCategories = List<String>.from(widget.record['foodCategory'] ?? []);
  }

  void _toggleCategory(String category) {
    setState(() {
      selectedCategories.contains(category)
          ? selectedCategories.remove(category)
          : selectedCategories.add(category);
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "금지 음식을 주의하세요!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "염분이 높은 음식, 뜨거운 음식, 기름이 많은 비계, 뼈, 껍질, 어패류 껍질 등 금지 음식은 미생물을 죽일 수 있습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "닫기",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "금지 음식을 주의하세요!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.red),
          onPressed: _showInfoDialog,
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
            borderRadius: BorderRadius.circular(12),
          ),
          side: isSelected
              ? BorderSide(color: Colors.grey, width: 2)
              : BorderSide.none,
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: allCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.5,
      ),
      itemBuilder: (context, index) {
        final category = allCategories[index];
        final isSelected = selectedCategories.contains(category);
        return _buildFoodCategoryButton(category, isSelected);
      },
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
                      child: Image.asset(
                        widget.record['imgUrl'] ?? 'images/placeholder.png',
                        height: 200,
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
                            height: 200,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'PM ${widget.record['time']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    '투여량\n${widget.record['weight'].toStringAsFixed(1)} kg',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoRow(),
              SizedBox(height: 16),
              _buildCategoryGrid(),
              //SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print('선택된 카테고리: $selectedCategories');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '저장하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}