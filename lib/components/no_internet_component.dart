import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternetComponent extends StatelessWidget {
  const NoInternetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16),
      color: Colors.red.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Text(
            'You are offline',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
