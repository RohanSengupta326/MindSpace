import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String issue;

  DetailsPage(this.issue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Text('Details for $issue'),
      ),
    );
  }
}
