import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Leads'),
            onTap: () {
              // Điều hướng đến trang "Leads"
              Navigator.of(context).pushReplacementNamed('/leads');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Customer'),
            onTap: () {
              // Điều hướng đến trang "Customer"
              Navigator.of(context).pushReplacementNamed('/customer');
            },
          ),
        ],
      ),
    );
  }
}
