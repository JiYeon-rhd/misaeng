import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthService {
  Future<String?> loginWithKakao() async {
    try {
      OAuthToken token;

      // 카카오톡 설치 여부에 따라 로그인 방식 결정
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      print('Access Token: ${token.accessToken}');
      return token.accessToken; // AccessToken 반환
    } catch (e) {
      print('Kakao login failed: $e');
      return null;
    }
  }
}
