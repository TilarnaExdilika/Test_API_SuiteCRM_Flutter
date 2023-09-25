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
  late String accessToken;

  @override
  void initState() {
    super.initState();
    getAccessTokenAndFetchData();
  }

  Future<void> getAccessTokenAndFetchData() async {
    final dio = Dio();
    accessToken = await getAccessToken(dio);
    fetchData();
  }

  Future<void> fetchData() async {
    final dio = Dio();

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

  void openLeadDetailsScreen(Map<String, dynamic> lead) async {
    final updatedLead = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeadDetailsPage(lead: lead),
      ),
    );

    if (updatedLead != null) {
      // Update the lead details if they were edited
      final index =
          leadsData.indexWhere((element) => element['id'] == updatedLead['id']);
      if (index != -1) {
        setState(() {
          leadsData[index] = updatedLead;
        });
      }
    }
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
                builder: (context) => const MyApp(),
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
                      openLeadDetailsScreen(lead);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
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
                                final leadId = lead['id'] as String;
                                final client = Dio();
                                final response = await client.delete(
                                  'https://dev.longphatcrm.vn/Api/index.php/V8/module/Leads/$leadId',
                                  options: Options(
                                    headers: {
                                      'Authorization': 'Bearer $accessToken',
                                    },
                                  ),
                                );

                                if (response.statusCode == 200) {
                                  fetchData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Xóa không thành công. Vui lòng thử lại sau.'),
                                    ),
                                  );
                                }

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
                // Handle Duplicate
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // Handle Delete
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                // Handle Search
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LeadDetailsPage extends StatefulWidget {
  final Map<String, dynamic> lead;

  const LeadDetailsPage({Key? key, required this.lead}) : super(key: key);

  @override
  _LeadDetailsPageState createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  late TextEditingController fullNameController;
  late TextEditingController phoneMobileController;

  @override
  void initState() {
    super.initState();
    fullNameController =
        TextEditingController(text: widget.lead['attributes']['full_name']);
    phoneMobileController =
        TextEditingController(text: widget.lead['attributes']['phone_mobile']);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Lead'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Họ và tên'),
            ),
          ),
          ListTile(
            title: TextField(
              controller: phoneMobileController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
            ),
          ),
          // Add more lead details here as needed
          // Example:
          // ListTile(
          //   title: Text('Email: ${widget.lead['attributes']['email']}'),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the updated lead details and return to the previous screen
          final updatedLead = {
            ...widget.lead,
            'attributes': {
              'full_name': fullNameController.text,
              'phone_mobile': phoneMobileController.text,
              // Add other attributes here
            },
          };
          Navigator.pop(context, updatedLead);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
