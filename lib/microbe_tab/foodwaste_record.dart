import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:misaeng/bar/top_bar_L2.dart';
import 'package:misaeng/microbe_tab/edit_record.dart';
import 'package:intl/date_symbol_data_local.dart';

class FoodWasteRecord extends StatefulWidget {
  const FoodWasteRecord({super.key});

  @override
  _FoodWasteRecordState createState() => _FoodWasteRecordState();
}

class _FoodWasteRecordState extends State<FoodWasteRecord> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  final Map<DateTime, List<Map<String, dynamic>>> records = {
    DateTime(2024, 11, 14): [
      {
        'time': '07:15',
        'weight': 1.0,
        'state': '금지 음식',
        'foodCategory': ['김치 및 절임류', '과일류'],
        'imgUrl': 'images/foodwaste_image.png'
      },
      {
        'time': '10:28',
        'weight': 0.6,
        'state': '미생물 분해 중',
        'foodCategory': ['밤 및 면류', '빵 및 곡류'],
        'imgUrl': 'images/foodwaste_image.png'
      },
    ],
    DateTime(2024, 11, 4): [
      {
        'time': '07:15',
        'weight': 1.0,
        'state': '금지 음식',
        'foodCategory': ['김치 및 절임류', '과일류'],
        'imgUrl': 'images/foodwaste_image.png'
      },
    ],
    DateTime(2024, 11, 22): [
      {'state': '자리비움'},
    ],
    DateTime(2024, 11, 23): [
      {'state': '자리비움'},
    ],
    DateTime(2024, 11, 24): [
      {'state': '자리비움'},
    ],
    DateTime(2024, 11, 25): [
      {
        'time': '15:34',
        'state': '미생물 분해 완료',
        'foodCategory': ['김치', '밥', '튀김'],
        'weight': 4.3,
        'imgUrl': 'mages/foodwaste_image.png'
      },
    ],
  };

  List<Map<String, dynamic>> _getRecordsForDate(DateTime date) {
    final dateWithoutTime = DateTime(date.year, date.month, date.day);
    return records[dateWithoutTime] ?? [];
  }

  List<Map<String, dynamic>> _getRecordsForMonth(DateTime date) {
    final monthStart = DateTime(date.year, date.month, 1);
    final monthEnd = DateTime(date.year, date.month + 1, 0);
    final List<Map<String, dynamic>> monthRecords = [];

    for (DateTime day = monthStart;
        day.isBefore(monthEnd) || day.isAtSameMomentAs(monthEnd);
        day = day.add(const Duration(days: 1))) {
      monthRecords.addAll(_getRecordsForDate(day));
    }

    return monthRecords;
  }

  bool _isRestrictedDay(DateTime date) {
    return _getRecordsForDate(date).any((record) => record['state'] == '금지 음식');
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
    });
  }

  void _onMonthChanged(DateTime focusedDay) {
    setState(() {
      _focusedDate = focusedDay;
      _selectedDate = null; // Reset selected date on month change
    });
  }

  @override
  Widget build(BuildContext context) {
    final recordsToShow = _selectedDate == null
        ? _getRecordsForMonth(_focusedDate)
        : _getRecordsForDate(_selectedDate!);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarL2(title: "음식물 투입 기록"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // 수평으로 20만큼의 패딩 추가
        child: Column(
          children: [
            SizedBox(height: 15),
            _buildCalendar(),
            SizedBox(height: 20),
            _buildHeader(),
            Divider(
              color: Color.fromARGB(32, 51, 51, 51),
              thickness: 1.0, // 선 두께
            ),
            SizedBox(height: 6),
            _buildRecordList(recordsToShow),

          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 가로 크기 조정
        padding: const EdgeInsets.all(8), // 달력과 테두리 사이의 여백
        decoration: BoxDecoration(
          color: Colors.white, // 배경색
          borderRadius: BorderRadius.circular(12), // 둥근 테두리
          border: Border.all(
            color: Color.fromARGB(47, 51, 51, 51), // 테두리 색상
            width: 1, // 테두리 두께
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2022),
              lastDay: DateTime(2025),
              focusedDay: _focusedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: _onDaySelected,
              onPageChanged: _onMonthChanged,
              locale: 'ko_KR',
              rowHeight: 38,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: "LineKrRg",
                  color: Color(0xFF333333),
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF333333),
                  size: 24,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF333333),
                  size: 24,
                ),
                headerPadding: EdgeInsets.only(bottom: 16),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: "LineKrRg",
                ),
                weekendStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: "LineKrRg",
                ),
                decoration: const BoxDecoration(),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: "LineKrRg",
                  color: Color(0xFF333333),
                ),
                selectedDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 187, 187, 187),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "LineKrRg",
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 187, 187, 187),
                    width: 2.0,
                  ),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontFamily: "LineKrRg",
                ),
                outsideDaysVisible: false, // 전달/다음 달 날짜 숨김
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final recordsForDay = _getRecordsForDate(day);
                  if (recordsForDay.isNotEmpty) {
                    final state =
                        recordsForDay.first['state']; // 해당 날짜의 첫 번째 기록 상태 확인
                    if (state == '자리비움') {
                      // 자리비움 상태인 경우 파란색으로 표시
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(89, 0, 123, 255), // 파란색 배경
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.white, // 흰색 텍스트
                              fontFamily: "LineKrRg",
                            ),
                          ),
                        ),
                      );
                    } else if (state == '금지 음식') {
                      // 금지 음식 상태인 경우 빨간색으로 표시
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(123, 255, 0, 0), // 빨간색 배경
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.white, // 흰색 텍스트
                              fontFamily: "LineKrRg",
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return null; // 기본 스타일 반환
                },
              ),
            ),
            const SizedBox(height: 8), // 달력과 범례 사이의 간격
            _buildLegend(), // 범례 추가
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // 범례를 중앙에 배치
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 금지 음식 범례
          Row(
            children: [
              Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Color.fromARGB(123, 255, 0, 0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "금지음식",
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            ],
          ),
          const SizedBox(width: 19), // 범례 간 간격
          // 자리비움 범례
          Row(
            children: [
              Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Color.fromARGB(89, 0, 123, 255),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "자리비움",
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final headerText = _selectedDate == null
        ? '전체 기록'
        : '${_selectedDate!.day}일 ${DateFormat.E('ko_KR').format(_selectedDate!)}요일';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              // 들여쓰기 공백 추가
              WidgetSpan(
                child: SizedBox(width: 8.5), // 8.5px 들여쓰기
              ),
              TextSpan(
                text: headerText,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'LineKrRg',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordList(List<Map<String, dynamic>> recordsToShow) {
    return Expanded(
      child: ListView.builder(
        itemCount: recordsToShow.length,
        itemBuilder: (context, index) {
          final record = recordsToShow[index];
          // 날짜 계산을 위해 선택된 날짜 또는 포커스된 날짜와 비교
          final recordDate = records.entries
              .firstWhere((entry) => entry.value.contains(record))
              .key; // 해당 record의 날짜

          return _buildRecordItem(record, recordDate);
        },
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> record, DateTime recordDate) {
    if (record['state'] == '자리비움') {
      return SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditRecord(
              date: recordDate, // recordDate로 수정
              record: record,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color.fromARGB(255, 240, 240, 240),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${DateFormat('yyyy. MM. dd').format(recordDate)}", // recordDate로 수정
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontFamily: "LineEnRg",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      record['time'],
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: "LineEnRg",
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Color.fromARGB(125, 182, 182, 182),
                      thickness: 1,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${record['weight'].toStringAsFixed(1)} kg",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontFamily: "LineEnRg",
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getStateIcon(record['state']),
                      color: _getStateColor(record['state']),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStateMessage(record['state']),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "LineKrRg",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'images/icon_arrow_right.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (record['foodCategory'] != null)
              Row(
                children: [
                  SizedBox(width: 28),
                  Text(
                    record['foodCategory']?.take(2).join(', ') ?? '',
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getStateIcon(String? state) {
    switch (state) {
      case '금지 음식':
        return Icons.warning_amber_rounded;
      case '미생물 분해 중':
        return Icons.loop_rounded;
      case '미생물 분해 완료':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.info;
    }
  }

  Color _getStateColor(String? state) {
    switch (state) {
      case '금지 음식':
        return Colors.red;
      case '미생물 분해 중':
        return Color(0xFF007AFF);
      case '미생물 분해 완료':
        return Color(0xFF007AFF);
      default:
        return Color(0xFF007AFF);
    }
  }

  String _getStateMessage(String? state) {
    switch (state) {
      case '금지 음식':
        return '금지 음식이 투입됐습니다.';
      case '미생물 분해 중':
        return '미생물이 열심히 분해 중입니다.';
      case '미생물 분해 완료':
        return '미생물이 분해를 완료했습니다.';
      default:
        return '상태 없음';
    }
  }
}
