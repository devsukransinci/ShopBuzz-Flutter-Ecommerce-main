import 'package:flutter/material.dart';

class CustomeScafoldMessage {
  final bool isWarning;

  CustomeScafoldMessage({required this.isWarning});

  showCustomeMessages(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message),
        backgroundColor: isWarning?Colors.red: Colors.green[900],
        
        
        ));
  }
}
