import 'package:dio/dio.dart';
import 'package:testsuiteapi/api.dart';

void main() async {
  // Tạo đối tượng `Dio`
  final dio = Dio();

  // Lấy access token
  final accessToken = await getAccessToken(dio);

  // Gọi API để lấy data
  final request = dio.get(
    'https://dev.longphatcrm.vn/Api/index.php/V8/module/Leads',
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );

  // Xử lý kết quả của tương lai
  request.then((response) {
    // Lấy data từ phản hồi API
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

  // Thực hiện yêu cầu API
  final response = await request;

  // Xử lý phản hồi API
  if (response.statusCode == 200) {
    // Lấy access token từ phản hồi API
    final token = response.data['access_token'];
    return token;
  } else {
    // Tạo ngoại lệ nếu yêu cầu API không thành công
    throw Exception('Failed to get access token: ${response.statusCode}');
  }
}
