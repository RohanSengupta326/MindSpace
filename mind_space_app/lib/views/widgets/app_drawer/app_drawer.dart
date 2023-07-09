import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

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
              'MindSpace',
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
              Get.back(); // Close the drawer
              Get.to(ChatScreen());
            },
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  Future<String> chatWithGPT(String message) async {
    final apiUrl = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_API_KEY',
    };

    final body = {
      'messages': [
        {'role': 'system', 'content': 'You are a user.'},
        {'role': 'user', 'content': message}
      ],
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final completions = data['choices'] as List<dynamic>;
      final completionText = completions.first['message']['content'] as String;
      return completionText;
    } else {
      throw Exception('Failed to chat with GPT');
    }
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add(message);
    });

    final response = await chatWithGPT(message);

    setState(() {
      _messages.add(response);
    });

    // Clear the message input field
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
