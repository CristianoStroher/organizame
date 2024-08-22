import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:provider/provider.dart';

class OrganizameCalendarButton extends StatelessWidget {
  final dateFormat = DateFormat('dd/MM/yyyy');

  final double? height;
  final TextEditingController controller;

  OrganizameCalendarButton({
    super.key,
    this.height,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: () async {
        final lastdate = DateTime.now().add(const Duration(days: 10 * 365));

        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: lastdate,
        );

        // if (selectedDate != null && context.mounted) {
        //   context.read<TaskController>().selectedDate = selectedDate;
        // }
       
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
              Icons.calendar_today,
              color: context.secondaryColor,
            ),
            const SizedBox(width: 10),
            Selector<TaskController, DateTime?>(
              selector: (context, controller) => controller.getSelectedDate,
              builder: (context, selectedDate, child) {
                if (selectedDate == null) {
                  return Text(
                    'Data',
                    style: TextStyle(color: context.primaryColor, fontSize: 16),
                  );
                } else {
                  return Text(
                    dateFormat.format(selectedDate),
                    style: TextStyle(color: context.primaryColor, fontSize: 16),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
