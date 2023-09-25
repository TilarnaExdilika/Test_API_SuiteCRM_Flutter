import 'package:dio/dio.dart';
import 'package:testsuiteapi/api.dart';
import 'package:flutter/material.dart';
import 'package:testsuiteapi/main.dart';

void main() {
  runApp(const Leads());
}

class Leads extends StatelessWidget {
  const Leads({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
              // Thêm nút để xem thêm thông tin về lead
              trailing: IconButton(
                icon: const Icon(Icons.info, color: Colors.deepPurpleAccent),
                onPressed: () {
                  // Mở màn hình mới để xem thêm thông tin về lead
                },
              ),
            ),
          );
        },
      ),
      endDrawer: Drawer(
        // Tạo EndDrawer bên phải
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
                // Xử lý khi người dùng chọn Create
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
            // Thêm các chức năng khác vào đây
          ],
        ),
      ),
    );
  }

  @override
  Widget navi(BuildContext context) {
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
              // Thêm nút để xem thêm thông tin về lead
              trailing: IconButton(
                icon: const Icon(Icons.info, color: Colors.deepPurpleAccent),
                onPressed: () {
                  // Mở màn hình mới để xem thêm thông tin về lead
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
