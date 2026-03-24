import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  LoadingIndicator({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(message!, style: TextStyle(color: Colors.grey.shade600))
          ],
        ],
      ),
    );
  }
}
