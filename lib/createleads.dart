import 'package:flutter/material.dart';

class CreateLeadPage extends StatefulWidget {
  @override
  _CreateLeadPageState createState() => _CreateLeadPageState();
}

class _CreateLeadPageState extends State<CreateLeadPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneMobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Leads Mới'),
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
              onPressed: () {
                String name = nameController.text;
                String description = descriptionController.text;
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String phoneMobile = phoneMobileController.text;
                // Gửi dữ liệu lên API để tạo lead mới
                // Sau khi tạo lead, bạn có thể thực hiện các hành động khác, ví dụ: quay lại trang danh sách leads
                // Lưu ý: Bạn cần gửi dữ liệu này lên API theo định dạng mà API đang yêu cầu.
                // Đoạn mã này chỉ mô phỏng việc lấy dữ liệu từ các trường nhập liệu.
                Navigator.pop(
                    context); // Đóng trang tạo lead và quay lại trang danh sách leads
              },
              child: const Text('Tạo'),
            ),
          ],
        ),
      ),
    );
  }
}
