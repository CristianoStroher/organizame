import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;

  const OrganizameElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? context.primaryColor,
          foregroundColor: textColor ?? context.primaryColorLight,
          textStyle: TextStyle(
            fontSize: fontSize ?? 20,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(3),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
