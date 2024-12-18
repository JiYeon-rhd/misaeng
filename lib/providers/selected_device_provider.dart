import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // http 패키지 import

class SelectedDeviceProvider with ChangeNotifier {
  final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;

  int? deviceId;
  String? deviceName;
  String? serialNum;

  int? microbeId;
  String? microbeName;
  // 미생물 색상 변환
  String? microbeColor;
  Color? microbeColorRGB;

  // 미생물 기분 (표정)
  String? microbeMood;
  // 미생물 태어난 일수
  int? bday;

  // 미생물 건강 상태 메세지
  String? microbeMessage;
  String? microbeMessageText;

  // 미생물 분해 상태
  String? microbeState;
  String? microbeStateText;
  String? microbeStateSummaryText;

  // 미생물 금지음식
  bool? forbidden;
  String? forbiddenText;

  // 음식 투여량
  String? foodWeightState;
  String? foodWeightStateText;

  double? weight;
  String? createdAt;

  // 온습도 변수
  double? temperature;
  double? humidity;
  String? temperatureState;
  String? temperatureStateText;
  String? humidityState;
  String? humidityStateText;

  // 데이터를 변수에 할당
  String? deviceMode;
  String? deviceModeText;
  bool? emptyState;
  double? emptyActiveTime;
  double? capsuleCycle;
  double? closeWaitTime;

  String? capsuleType;
  double? remain;
  String? date;
  // capsuleRemainMap 추가
  Map<String, int> capsuleRemainMap = {};
  List<Map<String, String>> recentThreeHistory = [];

  // 미생물, 음처기 데이터 가져오는 메서드
  Future<void> fetchDeviceDetails() async {
    if (deviceId == null) return;

    try {
      final response = await http.get(Uri.parse('$backendUrl/api/devices/1'));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('${data}');
        // data['data']는 기기 정보의 리스트입니다.
        List<dynamic> devices = data['data'];

        // 현재 deviceId와 일치하는 기기를 찾습니다.
        for (var device in devices) {
          if (device['deviceId'] == deviceId) {
            deviceName = device['deviceName'];
            serialNum = device['serialNum'];

            if (device['microbeInfo'] != null) {
              var microbeInfo = device['microbeInfo'];
              microbeId = microbeInfo['microbeId'];
              microbeName = microbeInfo['microbeName'];

              microbeColor = microbeInfo['microbeColor'];
              microbeColorRGB = getColorFromString(microbeColor ?? 'GREY');

              microbeMood = microbeInfo['microbeMood'];

              microbeMessage = microbeInfo['microbeMessage'];
              microbeMessageText = getMicrobeMessage(microbeMessage ?? 'GOOD');

              foodWeightState = microbeInfo['foodWeightState'];
              foodWeightStateText =
                  getFoodWeightStateMessage(foodWeightState ?? 'GOOD');

              microbeState = microbeInfo['microbeState'];
              microbeStateText =
                  getMicrobeStateMessage(microbeState ?? 'PROCESSING');
              microbeStateSummaryText =
                  getMicrobeStateSummaryMessage(microbeState ?? 'PROCESSING');

              forbidden = microbeInfo['forbidden'];
              forbiddenText = getForbiddenStateMessage(forbidden);

              weight = microbeInfo['weight'];

              bday = microbeInfo['bday'];
              createdAt = microbeInfo['createdAt'];
            } else {
              // microbeInfo가 null인 경우 변수 초기화 또는 기본값 설정
              microbeId = null;
              microbeName = '미생물 정보 없음';
              microbeColor = null;
              microbeMood = null;
              microbeMessage = null;
              foodWeightState = null;
              microbeState = null;
              weight = null;
              forbidden = null;
              bday = null;
              createdAt = null;
              print("'microbeInfo'가 null입니다.");
            }
            break; // 일치하는 기기를 찾았으므로 반복문 종료
          }
        }

        if (deviceName == null) {
          print("deviceId가 $deviceId인 기기를 찾을 수 없습니다.");
          deviceName = '기기 정보 없음';
          microbeName = '미생물 정보 없음';
        }
        notifyListeners(); // 상태 업데이트 알림
      } else {
        print("Failed to fetch device details: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching device details: $e");
    }
  }

  // 음처기 모드 불러오는 메서드
  Future<void> fetchDeviceState() async {
    if (deviceId == null || serialNum == null) return;

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/api/devices/state/$serialNum'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print("Device State Fetch Success: ${data['message']}");
        //print('${data}');
        // 필요 시 데이터 처리 로직 추가
        if (data['data'] != null) {
          // 데이터를 변수에 할당
          deviceMode = data['data']['deviceMode'];
          deviceModeText = getDeviceMode(deviceMode ?? "GENERAL");
          print("[디바이스 모드 출럭] : ${deviceModeText}");
          emptyState = data['data']['emptyState'];
          emptyActiveTime = (data['data']['emptyActiveTime'] as int).toDouble();
          capsuleCycle = data['data']['capsuleCycle'];
          closeWaitTime = (data['data']['closeWaitTime']as int).toDouble();

          // 이 데이터를 사용할 추가 로직을 구현
          // 예: 상태 업데이트, UI 반영
          notifyListeners();
        } else {
          print("데이터가 없습니다: ${data['message']}");
        }
      } else {
        print("Failed to fetch device state: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching device state: $e");
    }
  }

// 캡슐 데이터 가져오는 함수
  Future<void> fetchCapsuleDetails() async {
    if (serialNum == null) {
      print("serialNum이 설정되지 않았습니다.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/api/capsules/$serialNum'), // API 호출 URL
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data);

        // JSON 데이터에서 캡슐 정보 추출
        if (data['data'] != null && data['data']['capsuleRemain'] != null) {
          // capsuleRemain 데이터를 리스트로 처리
          List<dynamic> capsuleRemainList = data['data']['capsuleRemain'];

          // 데이터를 map 형태로 저장
          capsuleRemainMap.clear();
          for (var capsule in capsuleRemainList) {
            String type = capsule['capsuleType'];
            int remain = capsule['remain'];
            capsuleRemainMap[type] = remain; // type을 키로 사용해 remain 저장
          }

          // 특정 캡슐 타입 remain 확인 (예: MULTI)
          print("MULTI 캡슐 잔여량: ${capsuleRemainMap['MULTI']}");
          print("CARBS 캡슐 잔여량: ${capsuleRemainMap['CARBS']}");
          print("PROTEIN 캡슐 잔여량: ${capsuleRemainMap['PROTEIN']}");
          print("${capsuleRemainMap}");

          notifyListeners(); // 상태 변경 알림
        }

        if (data['data']['recentThreeHistory'] != null) {
          List<dynamic> recentHistoryList = data['data']['recentThreeHistory'];

          recentThreeHistory.clear(); // 기존 데이터 초기화
          for (var history in recentHistoryList) {
            if (history['capsuleType'] != null && history['date'] != null) {
              recentThreeHistory.add({
                "capsuleType": history['capsuleType'],
                "date": history['date'],
              });
            } else {
              print("누락된 데이터: $history");
            }
          }

          print("최근 3번의 투여 기록: $recentThreeHistory");
        } else {
          print("캡슐 데이터가 없습니다.");
        }
      } else {
        print("Failed to fetch capsule details: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching capsule details: $e");
    }
  }

  // 음처기 온/습도 데이터 가져오는 메서드
  Future<void> fetchMicrobeEnvironmentDetails() async {
    if (microbeId == null) {
      print("microbeId가 설정되지 않았습니다.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/api/microbes/environments/$microbeId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // JSON 데이터에서 환경 정보 추출
        if (data['data'] != null) {
          temperature = data['data']['temperature'];
          humidity = data['data']['humidity'];

          temperatureState = data['data']['temperatureState'];
          temperatureStateText = getStateMessage(temperatureState ?? 'GOOD');

          humidityState = data['data']['humidityState'];
          humidityStateText = getStateMessage(humidityState ?? 'GOOD');

          print("환경 데이터 업데이트 완료");
        } else {
          print("환경 데이터가 없습니다.");
        }

        notifyListeners(); // 상태 변경 알림
      } else {
        print(
            "Failed to fetch microbe environment details: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching microbe environment details: $e");
    }
  }

  // 음식물 투입 기록 월 단위 데이터 가져오는 메서드
  Future<Map<DateTime, String>> fetchMonthlyCalendarData({
    required int microbeId,
    required DateTime yearMonth,
  }) async {
    final String formattedDate =
        DateFormat('yyyy-MM').format(yearMonth); // yyyy-MM 형식으로 변환
    try {
      final response = await http.get(
        Uri.parse(
            '$backendUrl/api/microbes/$microbeId?yearMonth=$formattedDate'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> calendarData = data['data'];

        // 데이터를 Map<DateTime, String> 형식으로 변환
        final Map<DateTime, String> result = {};
        for (var item in calendarData) {
          final DateTime date = DateTime.parse(item['date']);
          final String calendarState = item['calendarState'];
          result[date] = calendarState;
        }
        return result;
      } else {
        print("Failed to fetch calendar data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching calendar data: $e");
    }
    return {};
  }

  // 음식물 투입 기록 일 단위 데이터 가져오는 메서드
  Future<Map<String, dynamic>?> fetchSelectedDateDetail({
    required int microbeId,
    required String date,
  }) async {
    try {
      final url = Uri.parse(
          '$backendUrl/api/microbes/detail/$microbeId?localDate=$date');
      print(date);
      print("Request URL: $url"); // URL 확인

      final response = await http.get(
        url,
        // headers: {
        //   // 필요한 경우 헤더 추가
        //   'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        //   'Content-Type': 'application/json',
        // },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data']; // 'data' 객체 반환
      } else {
        print("Failed to fetch details for the date: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error fetching details for the date: $e");
    }
    return null; // 오류가 발생하거나 데이터를 가져오지 못한 경우 null 반환
  }

  // 기기 정보 업데이트
  Future<void> updateDevice({
    required int deviceId,
    required String serialNum,
    required int microbeId,
  }) async {
    this.deviceId = deviceId;
    this.serialNum = serialNum;
    this.microbeId = microbeId;

    await fetchDeviceDetails(); // 기기 상세 정보 가져오기
    await fetchMicrobeEnvironmentDetails(); // 환경 데이터 가져오기
    // `fetchDeviceDetails()` 내부에서 `notifyListeners()`를 호출하므로 여기서는 호출하지 않습니다.
    await fetchDeviceState();
  }

  void updateDeviceMode(String newMode) {
    deviceMode = newMode;
    notifyListeners();
  }

  // 기기 아이디 업데이트
  void updateDeviceId(int id) {
    deviceId = id;
    notifyListeners();
  }

  void updateMicrobeColor(Color newColor) {
    microbeColorRGB = newColor;
    notifyListeners(); // 상태 변경 알림
  }

  // 선택 정보 초기화 (선택 해제)
  void clearSelection() {
    deviceId = null;
    serialNum = null;
    microbeId = null;
    deviceName = null;
    microbeName = null;
    microbeColor = null;
    microbeMood = null;
    microbeMessage = null;
    foodWeightState = null;
    microbeState = null;
    weight = null;
    forbidden = null;
    bday = null;
    createdAt = null;
    notifyListeners(); // 상태 변경 알림
  }

  // 현재 선택된 기기 정보를 출력하는 메서드
  void printCurrentSelection() {
    print(
        "DeviceId: ${deviceId ?? 'None'}, SerialNum: ${serialNum ?? 'None'}, MicrobeId: ${microbeId ?? 'None'}");
  }

  // 색상 변환 함수
  Color getColorFromString(String colorString) {
    switch (colorString.toUpperCase()) {
      case 'RED':
        return Colors.red;
      case 'ORANGE':
        return Colors.orange;
      case 'YELLOW':
        return Colors.yellow;
      case 'GREEN':
        return Colors.green;
      case 'BLUE':
        return Colors.blue;
      case 'PURPLE':
        return Colors.purple;
      case 'MAGENTA':
        return Colors.pinkAccent; // Flutter에서 Magenta에 가까운 색상
      case 'PINK':
        return Colors.pink;
      case 'BROWN':
        return Colors.brown;
      case 'BLACK':
        return Colors.black;
      case 'WHITE':
        return Colors.white;
      case 'LIME':
        return Colors.lime;
      case 'CYAN':
        return Colors.cyan;
      case 'DARK_BLUE':
        return Colors.blue[900]!; // 진한 파란색
      default:
        return Colors.grey; // 매칭되지 않는 경우 기본 색상
    }
  }

  // 미생물 건강상태 변환 함수
  String getMicrobeMessage(String microbeMessage) {
    switch (microbeMessage.toUpperCase()) {
      case 'GOOD':
        return '건강합니다!';
      case 'BAD':
        return '상태가 좋지 않습니다..';
      case 'FULL':
        return '음식을 과도하게 먹었습니다..';
      case 'DANGER':
        return '위험합니다!!';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

  // 미생물 분해 상태 변환 함수
  String getMicrobeStateMessage(String microbeState) {
    switch (microbeState.toUpperCase()) {
      case 'FORBIDDEN':
        return '금지음식이 포함되었습니다.';
      case 'EMPTY':
        return '자리 비움 상태입니다.';
      case 'COMPLETE':
        return '분해가 완료되었습니다.';
      case 'PROCESSING':
        return '현재 음식을 분해 중입니다.';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

  // 미생물 분해 상태 변환 함수 (summary)
  String getMicrobeStateSummaryMessage(String microbeState) {
    switch (microbeState.toUpperCase()) {
      case 'FORBIDDEN':
        return '완료';
      case 'EMPTY':
        return '완료';
      case 'COMPLETE':
        return '분해중';
      case 'PROCESSING':
        return '완료';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

  // 음식 투여량 변환 함수
  String getFoodWeightStateMessage(String foodWeightState) {
    switch (foodWeightState.toUpperCase()) {
      case 'GOOD':
        return '적절';
      case 'FULL':
        return '과다';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

  // 금지 음식 변환 함수
  String getForbiddenStateMessage(bool? forbidden) {
    switch (forbidden) {
      case true:
        return '있음';
      case false:
        return '없음';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

  // 온 습도 변환 함수
  String getStateMessage(String state) {
    switch (state.toUpperCase()) {
      case 'GOOD':
        return '적절';
      case 'LOW':
        return '부족';
      case 'HIGH':
        return '높음';
      default:
        return '알 수 없는 상태입니다.';
    }
  }


  // 모드 변경
  String getDeviceMode(String deviceMode) {
  switch (deviceMode.toUpperCase()) {
    case 'GENERAL':
      return '일반';
    case 'DEHUMID':
      return '제습';
    case 'SAVING':
      return '절전';
    default:
      return '알 수 없는 모드입니다.';
  }
}
}
