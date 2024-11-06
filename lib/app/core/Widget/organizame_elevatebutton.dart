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
  final Color? borderColor;
  final bool? enabled;
  final Color? disabledColor;

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
    this.borderColor,
    this.enabled,
    this.disabledColor,
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
          disabledBackgroundColor: disabledColor ?? Colors.grey[400],
          disabledForegroundColor: Colors.grey[700],
          textStyle: TextStyle(
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(3),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
