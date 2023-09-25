import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testsuiteapi/api.dart';

class CreateLeadPage extends StatefulWidget {
  const CreateLeadPage({Key? key}) : super(key: key);

  @override
  _CreateLeadPageState createState() => _CreateLeadPageState();
}

class _CreateLeadPageState extends State<CreateLeadPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneMobileController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo KH tiềm năng'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên KH'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Họ'),
            ),
            TextField(
              controller: phoneMobileController,
              decoration:
                  const InputDecoration(labelText: 'Số điện thoại di động'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Tạo access token
                var accessToken = await getAccessToken(Dio());

                // Tạo body của request
                var body = {
                  "data": {
                    "type": "Lead",
                    "attributes": {
                      "name": nameController.text,
                      "description": descriptionController.text,
                      "salutation": "Mr.",
                      "first_name": firstNameController.text,
                      "last_name": lastNameController.text,
                      "phone_mobile": phoneMobileController.text,
                      "account_name": "ABC Company",
                      "account_description": "Mô tả của công ty ABC",
                      "opportunity_name": "Opportunity XYZ",
                      "opportunity_amount": 50000
                    }
                  }
                };

                // Tạo client
                var dio = Dio();

                // Gửi request lên API
                var response = await dio.post(
                  urlCreate,
                  data: body,
                  options: Options(
                    headers: {
                      'Authorization':
                          'Bearer $accessToken', // Thêm header Authorization để xác thực
                    },
                  ),
                );

                // Kiểm tra kết quả của request
                if (response.statusCode == 200) {
                  // Tạo lead thành công
                  Navigator.pop(
                      context); // Đóng trang tạo lead và quay lại trang danh sách leads
                } else {
                  // Tạo lead không thành công
                  // Hiển thị thông báo lỗi
                }
              },
              child: const Text('Tạo'),
            ),
          ],
        ),
      ),
    );
  }
}
