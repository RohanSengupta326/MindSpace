import 'package:flutter/material.dart';

class AlertBoxWidget extends StatelessWidget {
  var message;

  AlertBoxWidget(
    this.message,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.toString(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              shadowColor: MaterialStatePropertyAll(
                  Theme.of(context).scaffoldBackgroundColor),
              elevation: MaterialStatePropertyAll(16),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor),
            ),
            child: Text('Ok!'),
          ),
        ],
      ),
    );
  }
}
