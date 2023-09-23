import 'package:dio/dio.dart';
import 'package:testsuiteapi/api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> leadsData = []; // Danh sách dữ liệu từ API

  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi hàm để lấy dữ liệu từ API khi màn hình được khởi tạo
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

  Future<void> fetchData() async {
    final dio = Dio();
    final accessToken = await getAccessToken(dio);

    final request = dio.get(
      urlLeads,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    request.then((response) {
      setState(() {
        leadsData = List<Map<String, dynamic>>.from(response.data['data']);
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Data'),
      ),
      body: ListView.builder(
        itemCount: leadsData.length,
        itemBuilder: (context, index) {
          final lead = leadsData[index];
          return ListTile(
            title: Text(lead['attributes']['full_name']),
            subtitle: Text(lead['attributes']['email']),
            // Thêm các trường dữ liệu khác của lead ở đây
          );
        },
      ),
    );
  }
}
