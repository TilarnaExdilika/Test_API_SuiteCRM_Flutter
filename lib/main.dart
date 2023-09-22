import 'package:dio/dio.dart';
import 'package:testsuiteapi/api.dart';

void main() async {
  final dio = Dio();

  // Gọi API để lấy access token
  final request = dio.post(
    urlToken,
    data: {
      'grant_type': grantType,
      'client_id': clientId,
      'client_secret': clientSecret,
      'username': username,
      'password': password,
    },
  );

  // =))))))))))))))))))))))))
  request.then((response) {
    // Lấy access token từ  API
    final token = response.data['access_token'];

    // In access token
    print(token);
  }).catchError((error) {
    // Xử lý lỗi
    print(error);
  });
}
