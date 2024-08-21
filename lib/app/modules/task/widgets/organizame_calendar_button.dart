import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameCalendarButton extends StatelessWidget {
  final double? height;
  const OrganizameCalendarButton({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: height ?? 48,
      decoration: BoxDecoration(
        color: context.primaryColorLight,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: context.primaryColor, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Icon(
            Icons.calendar_today,
            color: context.secondaryColor,
            ),
          const SizedBox(width: 10),
          Text('Data', style: TextStyle(color: context.primaryColor, fontSize: 17)),
        ],
      ),
    );
  }
}
