import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:mind_space_app/controller/auth_user_controller.dart';

class AppDrawer extends StatelessWidget {
  final authUserController = AuthUserController();

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
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Theme.of(context).primaryColor)),
            onPressed: () => authUserController.logOut(),
            child: Text('LogOut'),
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
  bool _isLoading = false; // Track loading state

  Future<String> chatWithGPT(String message) async {
    final apiUrl = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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',
    };

    final body = {
      'model': 'gpt-3.5-turbo-0301',
      'messages': [
        {'role': 'system', 'content': 'You are a user.'},
        {'role': 'user', 'content': message}
      ],
      'max_tokens': 1000,
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: jsonEncode(body));

    log(response.body);

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
      _isLoading = true;
    });

    final response = await chatWithGPT(message);

    setState(() {
      _messages.add(response);
      _isLoading = false;
    });

    // Clear the message input field
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'AI Chat : ask AI about your mental health',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 15,
          ),
        ),
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
                  onPressed: _isLoading // Disable button while loading
                      ? null
                      : () {
                          final message = _messageController.text;
                          if (message.isNotEmpty) {
                            _sendMessage(message);
                          }
                        },
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(), // Show loading indicator
            ),
        ],
      ),
    );
  }
}
