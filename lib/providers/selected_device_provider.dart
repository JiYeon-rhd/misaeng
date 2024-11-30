import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // http 패키지 import

class SelectedDeviceProvider with ChangeNotifier {
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

  double? temperature;
  double? humidity;
  String? temperatureState;
  String? temperatureStateText;
  String? humidityState;
  String? humidityStateText;



  final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;

  void updateDeviceId(int id) {
    deviceId = id;
    notifyListeners();
  }

  // 미생물, 음처기 데이터 가져오는 메서드
  Future<void> fetchDeviceDetails() async {
    if (deviceId == null) return;

    try {
      final response = await http.get(Uri.parse('$backendUrl/api/devices/1'));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

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
}
