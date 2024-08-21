import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const OrganizameTextField({
    super.key,
    required this.label,
    this.controller,
    this.maxLines = 3,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      maxLines: maxLines, // Permite 3 linhas de altura
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        labelStyle: TextStyle(
          color: context.primaryColor,
          fontSize: context.titleDefaut.fontSize,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(
            color: context.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(
            color: context.primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        isDense: true, // Mantém a densidade visual
      ),
    );
  }
}
