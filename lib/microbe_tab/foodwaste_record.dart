import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:misaeng/providers/selected_device_provider.dart';
import 'package:provider/provider.dart';
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
  DateTime? _selectedDate = DateTime.now();
  Map<DateTime, String> _calendarStates = {};
  Map<String, dynamic>? _selectedDateData; // 선택된 날짜의 데이터
  bool _isLoadingDetails = false; // 데이터 로딩 상태

  @override
  void initState() {
    super.initState();
    _loadCalendarData(); // 달력 데이터를 초기화
  }

  //월 단위 데이터 가져오는 메서드
  Future<void> _loadCalendarData() async {
    final provider =
        Provider.of<SelectedDeviceProvider>(context, listen: false);

    // microbeId와 현재 월을 기반으로 데이터 가져오기
    if (provider.microbeId != null) {
      final data = await provider.fetchMonthlyCalendarData(
        microbeId: provider.microbeId!,
        yearMonth: _focusedDate, // 현재 포커스된 달력의 날짜
      );
      //print("[FoodWaste_Record]: $data");

      // 시간을 제거하여 순수 날짜만 포함되도록 변환
      final updatedCalendarStates = <DateTime, String>{};
      data.forEach((key, value) {
        final dateWithoutTime = DateTime(key.year, key.month, key.day);
        updatedCalendarStates[dateWithoutTime] = value;
      });
      setState(() {
        _calendarStates = updatedCalendarStates;
      });

      //print('[FoodWaste_Record] 달력 상태 업데이트: $_calendarStates');
    } else {
      print("microbeId가 없습니다.");
    }
  }

  // 일 단위 데이터 가져오는 메서드
  Future<void> _fetchSelectedDateData(DateTime date) async {
    final provider =
        Provider.of<SelectedDeviceProvider>(context, listen: false);

    if (provider.microbeId != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      try {
        final data = await provider.fetchSelectedDateDetail(
          microbeId: provider.microbeId!,
          date: formattedDate,
        );

        setState(() {
          _selectedDateData = data; // 데이터 저장
          _isLoadingDetails = false; // 로딩 완료
        });

        print("[SelectedDateData]: $_selectedDateData");
      } catch (e) {
        print("데이터를 가져오는 중 오류 발생: $e");
        setState(() {
          _isLoadingDetails = false; // 로딩 완료
        });
      }
    } else {
      print("microbeId가 없습니다.");
      setState(() {
        _isLoadingDetails = false; // 로딩 완료
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
      _isLoadingDetails = true; // 로딩 시작
    });

    _fetchSelectedDateData(selectedDay);
  }

  void _onMonthChanged(DateTime focusedDay) {
    setState(() {
      _focusedDate = focusedDay;
      _selectedDate = null; // 선택된 날짜 초기화
    });
    _loadCalendarData(); // 새로운 월 데이터를 가져오기
  }

  @override
  Widget build(BuildContext context) {
    // final recordsToShow = _selectedDate == null
    //     ? _getRecordsForMonth(_focusedDate)
    //     : _getRecordsForDate(_selectedDate!);

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
            //_buildRecordList(recordsToShow),
            Expanded(child: _buildSelectedDateDetails()), // 선택된 날짜 데이터 추가
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateDetails() {
    if (_isLoadingDetails) {
      return Center(child: CircularProgressIndicator()); // 로딩 중 표시
    }

    if (_selectedDateData == null) {
      return Center(child: Text("날짜를 선택해주세요."));
    }

    final totalWeight = _selectedDateData!['totalWeight'] ?? 0.0;
    final detailList = _selectedDateData!['detailList'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: detailList.length,
            itemBuilder: (context, index) {
              final item = detailList[index];
              return _buildDetailCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> detail) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditRecord(
              date: DateTime.parse(_selectedDateData!['date']), // 선택된 날짜
              record: detail,
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
                      "${DateFormat('yyyy. MM. dd').format(DateTime.parse(_selectedDateData!['date']))}",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontFamily: "LineEnRg",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      detail['time'] ?? '정보 없음',
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
                      "${detail['weight']?.toStringAsFixed(1) ?? '0.0'} kg",
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
                      _getStateIcon(detail['microbeState']),
                      color: _getStateColor(detail['microbeState']),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStateMessage(detail['microbeState']),
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
            if (detail['foodCategory'] != null)
              Row(
                children: [
                  SizedBox(width: 28),
                  Text(
                    detail['foodCategory']
                            ?.map(
                                (category) => _getFoodCategoryMessage(category))
                            ?.take(2)
                            ?.join(', ') ??
                        '',
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                      fontFamily: "LineKrRg",
                    ),
                  ),
                ],
              ),
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
                  final dateWithoutTime =
                      DateTime(day.year, day.month, day.day); // 시간 제거
                  final state = _calendarStates[dateWithoutTime];

                  if (state == 'EMPTY') {
                    // 자리비움 상태인 경우
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
                            color: Colors.white,
                            fontFamily: "LineKrRg",
                          ),
                        ),
                      ),
                    );
                  } else if (state == 'FORBIDDEN') {
                    // 금지 음식 상태인 경우
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
                            color: Colors.white,
                            fontFamily: "LineKrRg",
                          ),
                        ),
                      ),
                    );
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
        ? '기록'
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

  IconData _getStateIcon(String? state) {
    switch (state?.toUpperCase()) {
      case 'FORBIDDEN':
        return Icons.warning_amber_rounded; // 금지 음식
      case 'PROCESSING':
        return Icons.loop_rounded; // 미생물 분해 중
      case 'COMPLETE':
        return Icons.check_circle_outline_rounded; // 미생물 분해 완료
      default:
        return Icons.info; // 알 수 없는 상태
    }
  }

  Color _getStateColor(String? state) {
    switch (state?.toUpperCase()) {
      case 'FORBIDDEN':
        return Colors.red; // 금지 음식
      case 'PROCESSING':
        return Color(0xFF007AFF); // 미생물 분해 중
      case 'COMPLETE':
        return Color(0xFF007AFF); // 미생물 분해 완료
      default:
        return Color(0xFF007AFF); // 알 수 없는 상태
    }
  }

  String _getStateMessage(String? state) {
    switch (state?.toUpperCase()) {
      case 'FORBIDDEN':
        return '금지 음식이 투입되었습니다.';
      case 'PROCESSING':
        return '미생물이 열심히 분해 중 입니다.';
      case 'COMPLETE':
        return '미생물이 분해를 완료했습니다.';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

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
}
