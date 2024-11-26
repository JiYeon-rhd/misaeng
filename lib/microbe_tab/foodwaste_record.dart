import 'package:flutter/material.dart';
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
    DateTime(2024, 11, 12): [
      {
        'time': '03:28',
        'weight': 0.5,
        'state': '미생물 분해 완료',
        'foodCategory': ['해산물 요리', '기타 음식 및 간식'],
        'imgUrl': 'images/foodwaste_image.png'
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
      body: Column(
        children: [
          _buildCalendar(),
          const Divider(),
          _buildHeader(),
          _buildRecordList(recordsToShow),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: TableCalendar(
          firstDay: DateTime(2022),
          lastDay: DateTime(2025),
          focusedDay: _focusedDate,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: _onDaySelected,
          onPageChanged: _onMonthChanged,
          locale: 'ko_KR',
          rowHeight: 52,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 187, 187, 187),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            todayDecoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 187, 187, 187),
                width: 2.0,
              ),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (_isRestrictedDay(day)) {
                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFF0000),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final headerText = _selectedDate == null
        ? '전체 기록'
        : '${_selectedDate!.year}년 ${_selectedDate!.month.toString().padLeft(2, '0')}월 ${_selectedDate!.day.toString().padLeft(2, '0')}일 기록';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          headerText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
          return _buildRecordItem(record);
        },
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> record) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditRecord(
              date: _selectedDate ?? _focusedDate,
              record: record,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${record['time']} | ${record['weight'].toStringAsFixed(1)} kg",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: '투입된 음식물: ',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: record['foodCategory']?.take(2).join(', ') ?? '',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStateIcon(String? state) {
    switch (state) {
      case '금지 음식':
        return Icons.warning_amber_sharp;
      case '미생물 분해 중':
        return Icons.loop;
      case '미생물 분해 완료':
        return Icons.check_circle_outline;
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
