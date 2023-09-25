import 'package:dio/dio.dart';

const String urlLeads =
    'https://dev.longphatcrm.vn/Api/index.php/V8/module/Leads';
const String urlCreate = 'https://dev.longphatcrm.vn/Api/index.php/V8/module';
const String urlToken = 'https://dev.longphatcrm.vn/Api/index.php/access_token';
const String grantType = 'password';
const String clientId = '31395009-38f9-8155-37aa-650a5a82a2d0';
const String clientSecret = 'rO2GElsqtAojbXzRt9ts';
const String username = 'nv';
const String password = '12131415@!';

Future<String> getAccessToken(Dio dio) async {
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

  final response = await request;

  if (response.statusCode == 200) {
    final token = response.data['access_token'];
    return token;
  } else {
    throw Exception('Failed to get access token: ${response.statusCode}');
  }
}
