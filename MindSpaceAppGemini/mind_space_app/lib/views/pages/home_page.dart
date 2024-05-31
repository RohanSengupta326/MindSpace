import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_html/flutter_html.dart';

import '../widgets/app_drawer/app_drawer.dart';

class Issue {
  final String headline;
  final String text;

  Issue({
    required this.headline,
    required this.text,
  });
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imagePaths = [
    'assets/images/b1.jpg',
    'assets/images/b2.jpg',
    'assets/images/b3.jpg',
    'assets/images/b4.jpg',
    'assets/images/b5.jpg',
    // Add more image paths here
  ];

  List<String> assetPaths = [];
  @override
  void initState() {
    super.initState();
    assetPaths = List<String>.generate(
      20,
      (index) => imagePaths[Random().nextInt(imagePaths.length)],
    );
  }

  Future<List<Issue>> fetchMentalHealthIssues() async {
    final url = Uri.parse('https://api.nhs.uk/mental-health');
    final headers = {'subscription-key': 'a50a83d973704b2c9dbce6fdf8ad3e7a'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(response.body);
      final List<dynamic> issues = data['hasPart'] as List<dynamic>;
      final List<Issue> issueList = issues
          .map((issue) => Issue(
                headline: issue['headline'] as String,
                text: issue['hasPart'][0]['text'] as String,
              ))
          .toList();
      return issueList;
    } else {
      throw Exception('Failed to fetch mental health issues');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context)
                    .primaryColor, // Change Custom Drawer Icon Color
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 35),
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Know Your Mind',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Issue>>(
              future: fetchMentalHealthIssues(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 3,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final issues = snapshot.data!;
                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                    ),
                    itemCount: issues.length,
                    itemBuilder: (context, index) {
                      final issue = issues[index];
                      final assetPath = assetPaths[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to new page for the selected issue
                          Get.to(
                            DetailsPage(
                              issue: issues[index].headline,
                              text: issues[index].text,
                              assetPath: assetPath,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(assetPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              issues[index].headline,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text('Sorry! Something Went Wrong!'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String issue;
  final String text;
  final String assetPath;

  DetailsPage(
      {required this.issue, required this.text, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: Get.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(assetPath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: Get.height * 0.2, left: 16, right: 16),
                child: Text(
                  issue,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).appBarTheme.backgroundColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                data: text,
                style: {
                  'body': Style(fontSize: FontSize(18)),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
