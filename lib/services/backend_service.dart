import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class BackendService {
  final String backendUrl = dotenv.env['FLUTTER_APP_API_URL']!;

  // 백엔드로 Access Token 전송
  Future<String?> sendTokenToBackend(String accessToken) async {
    try {
      
      log('Sending POST request to $backendUrl/api/auth/kakao');
      log('Headers: Authorization: Bearer $accessToken');

      final response = await http.post(
        Uri.parse('$backendUrl/api/auth/kakao'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // 요청 후 상태 및 응답 로그 출력
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Token sent successfully to backend');
        return response.body; // 백엔드에서 받은 JWT 토큰
      } else {
        print('Failed to send token: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending token to backend: $e');
      return null;
    }
  }
}
