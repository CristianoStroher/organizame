import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:provider/provider.dart';

class OrganizameTimeButton extends StatelessWidget {
  final double? height;
  final String? label;
  final TextEditingController controller;

  const OrganizameTimeButton({
    super.key,
    this.height,
    this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: () async {
        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          final now = DateTime.now();
          final dateTime = DateTime(now.year, now.month, now.day,
              selectedTime.hour, selectedTime.minute);
          context.read<TaskController>().setSelectedTime = dateTime;
        }

      },
      child: Container(
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
              Icons.access_time,
              color: context.secondaryColor,
            ),
            const SizedBox(width: 10),
            if (label != null)
              Text(
                label!,
                style: TextStyle(color: context.primaryColor, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
