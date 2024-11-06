import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:provider/provider.dart';

class OrganizameTimeButton extends StatelessWidget {
  final timeFormat = DateFormat('HH:mm');
  final ValueChanged<DateTime>? onDateSelected;
  final double? height;
  final String? label;
  final TextEditingController controller;
  final Color color;
  final Function(TimeOfDay)? onTimeSelected;

  OrganizameTimeButton({
    super.key,
    this.height,
    this.label,
    required this.controller,
    this.onDateSelected,
    required this.color,
    this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: () async {
        // Pega o horário atual do controller se existir
        TimeOfDay initialTime;
        try {
          if (controller.text.isNotEmpty) {
            final time = timeFormat.parse(controller.text);
            initialTime = TimeOfDay(hour: time.hour, minute: time.minute);
          } else {
            initialTime = TimeOfDay.now();
          }
        } catch (e) {
          initialTime = TimeOfDay.now();
        }

        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (selectedTime != null) {
          // Atualiza o controlador com o novo horário
          final formattedTime = selectedTime.format(context);
          controller.text = formattedTime;

          // Notifica sobre a mudança
          if (onTimeSelected != null) {
            onTimeSelected!(selectedTime);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        height: height ?? 48,
        decoration: BoxDecoration(
          color: color,
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
                controller.text.isNotEmpty ? controller.text : label!,
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
