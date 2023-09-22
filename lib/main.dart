import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testsuiteapi/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Danh sách Leads
  List<Lead>? leads = [];

  @override
  void initState() {
    super.initState();
    // Lấy token
    _getAccessToken();
  }

  // Lấy token
  Future<void> _getAccessToken() async {
    // Tạo đối tượng Dio
    final dio = Dio();

    // Tạo yêu cầu HTTP
    final response = await dio.post(
      urlToken,
      data: {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientSecret,
        'username': username,
        'password': password,
      },
    );

    // Xử lý kết quả trả về
    if (response.statusCode == 200) {
      // Token
      final token = response.data['access_token'];

      // Gọi API Leads
      _getLeads(token);
    } else {
      // Lỗi
      print(response.statusCode);
      print(response.data);
    }
  }

  // Gọi API Leads
  Future<void> _getLeads(String token) async {
    // Tạo đối tượng Dio
    final dio = Dio();

    // Thiết lập header
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Tạo yêu cầu HTTP
    final response = await dio.get(urlApi);

    // Xử lý kết quả trả về
    if (response.statusCode == 200) {
      // Danh sách Leads
      leads =
          response.data['results']?.map((lead) => Lead.fromJson(lead)).toList();
      print(leads);

      // Cập nhật trạng thái
      setState(() {});
    } else {
      // Lỗi
      print(response.statusCode);
      print(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SuiteCRM',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách Leads'),
        ),
        body: leads?.isEmpty ?? true
            ? const Center(
                child: Text('Không có Lead nào'),
              )
            : ListView.builder(
                itemCount: leads?.length,
                itemBuilder: (context, index) {
                  final lead = leads![index];
                  return ListTile(
                    title: Text(lead.name),
                  );
                },
              ),
      ),
    );
  }
}

class Lead {
  String id;
  String name;

  Lead({
    required this.id,
    required this.name,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
    );
  }
}
