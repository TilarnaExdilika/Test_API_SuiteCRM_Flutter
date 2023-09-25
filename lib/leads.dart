import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testsuiteapi/api.dart';
import 'package:testsuiteapi/createleads.dart';
import 'package:testsuiteapi/main.dart';

void main() {
  runApp(const Leads());
}

class Leads extends StatelessWidget {
  const Leads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeadsPage(),
    );
  }
}

class LeadsPage extends StatefulWidget {
  const LeadsPage({Key? key}) : super(key: key);

  @override
  _LeadsPageState createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  List<Map<String, dynamic>> leadsData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(), // Trở về trang chính
              ),
            );
          },
        ),
        title: const Text('KH tiềm năng'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: leadsData.length,
        itemBuilder: (context, index) {
          final lead = leadsData[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.deepPurpleAccent),
              title: Text(lead['attributes']['full_name']),
              subtitle: Text(lead['attributes']['phone_mobile']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.info, color: Colors.deepPurpleAccent),
                    onPressed: () {
                      // Mở màn hình mới để xem thêm thông tin về lead
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Hiển ra thông báo bạn có muốn xóa ?
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Xóa khách hàng tiềm năng'),
                          content: const Text(
                              'Bạn có chắc chắn muốn xóa khách hàng tiềm năng này không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Không'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Xác định id của khách hàng tiềm năng
                                final leadId = lead[
                                    'id']; // Thay lead['id'] bằng cách lấy id thực tế từ dữ liệu của bạn

                                // Tạo client
                                final client = Dio();

                                // Gửi request DELETE lên API để xóa khách hàng tiềm năng
                                final response = await client.delete(
                                  'https://dev.longphatcrm.vn/Api/index.php/V8/moduleLeads/$leadId',
                                  options: Options(
                                    headers: {
                                      'Authorization': 'Bearer $accessToken',
                                    },
                                  ),
                                );

                                // Kiểm tra kết quả của request
                                if (response.statusCode == 200) {
                                  // Xóa thành công, cập nhật danh sách leads
                                  fetchData();
                                } else {
                                  // Xóa không thành công, hiển thị thông báo lỗi
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Xóa không thành công. Vui lòng thử lại sau.'),
                                    ),
                                  );
                                }

                                // Đóng hộp thoại xác nhận
                                Navigator.pop(context);
                              },
                              child: const Text('Có'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Chức năng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create'),
              onTap: () {
                // Điều hướng đến trang tạo lead khi ấn vào Create
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateLeadPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Duplicate'),
              onTap: () {
                // Xử lý khi người dùng chọn Duplicate
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // Xử lý khi người dùng chọn Delete
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                // Xử lý khi người dùng chọn Search
              },
            ),
          ],
        ),
      ),
    );
  }
}
