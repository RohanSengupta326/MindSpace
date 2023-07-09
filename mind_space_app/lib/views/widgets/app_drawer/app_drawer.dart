import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor, // Use primary color from theme
            ),
            child: Text(
              'App Drawer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              // Wrap the leading with a Container and set its color to green
              color: Colors.green,
              child: Icon(Icons.home, color: Colors.white),
            ),
            title: Text('Home Page'),
            onTap: () {
              // Navigate to Home Page
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Container(
              // Wrap the leading with a Container and set its color to green
              color: Colors.green,
              child: Icon(Icons.chat, color: Colors.white),
            ),
            title: Text('AI Chat Section'),
            onTap: () {
              // Navigate to AI Chat Section
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/chat');
            },
          ),
        ],
      ),
    );
  }
}
