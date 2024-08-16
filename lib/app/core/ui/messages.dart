import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class Messages {
  final BuildContext context;

  Messages._(this.context);

  factory Messages.of(BuildContext context) => Messages._(context);

  void showError(String message) => _showMessage(message, context.errorColor);

  void showInfo(String message) =>
      _showMessage(message, context.primaryColor);

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
