import 'package:dio/dio.dart';
import 'package:testsuiteapi/api.dart';

void main() async {
  // Tạo đối tượng `Dio`
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

  // Xử lý kết quả của tương lai
  request.then((response) {
    // Lấy access token từ phản hồi API
    final token = response.data['access_token'];

    // In access token ra màn hình
    print(token);
  }).catchError((error) {
    // Xử lý lỗi
    print(error);
  });
}
