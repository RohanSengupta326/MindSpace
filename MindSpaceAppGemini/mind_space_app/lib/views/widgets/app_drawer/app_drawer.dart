import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:mind_space_app/controller/auth_user_controller.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  int chatCounter = 0;
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  bool _isLoading = false; // Track loading state

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAvqcw0b5UBlqayetICJZTuti0UrJnxEeU',
  );

  Future<String> chatWithGPT(String message) async {
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    return response.text ?? 'Something went wrong';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Chat With AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.5,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final sender = index % 2 == 0 ? 'You' : 'Mind Mate';

                    return ListTile(
                      // leading: Text(
                      //   (chatCounter % 2) == 0 ? 'ChatGPT\n\n\n' : 'You\n\n\n',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 20,
                      //     color: chatCounter % 2 == 0
                      //         ? Colors.green
                      //         : Colors.black,
                      //   ),
                      // ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${sender}\n',
                              style: TextStyle(
                                color: index % 2 == 0
                                    ? Colors.black
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '$message\n',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ), // Show loading indicator
                ),
              Center(
                child: Container(
                  width: screenWidth * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 3,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 3,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.green,
                        ),
                        onPressed: _isLoading // Disable button while loading
                            ? null
                            : () {
                                final message = _messageController.text;
                                _messageController.clear();
                                if (message.isNotEmpty) {
                                  _sendMessage(message);
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
