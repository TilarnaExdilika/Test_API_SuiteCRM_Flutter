import 'package:dio/dio.dart';
import 'package:testsuiteapi/api.dart';

void main() async {
  final dio = Dio();

  final accessToken = await getAccessToken(dio);

  // Gọi API để lấy data
  final request = dio.get(
    urlApi,
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );

  // Xử lý kq
  request.then((response) {
    // Lấy data từ API
    final data = response.data;

    // In data ra màn hình
    print(data);
  }).catchError((error) {
    // Xử lý lỗi
    print(error);
  });
}

Future<String> getAccessToken(Dio dio) async {
  // Tạo đối tượng `DioRequest`
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

  // Thực hiện API request
  final response = await request;

  // Xử lý
  if (response.statusCode == 200) {
    // Lấy access token từ API
    final token = response.data['access_token'];
    return token;
  } else {
    // nếu yêu cầu API không thành công
    throw Exception('Failed to get access token: ${response.statusCode}');
  }
}
