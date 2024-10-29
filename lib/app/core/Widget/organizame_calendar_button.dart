// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:organizame/app/core/ui/theme_extensions.dart';
// import 'package:organizame/app/modules/task/task_controller.dart';
// import 'package:provider/provider.dart';

// class OrganizameCalendarButton extends StatelessWidget {
//   final dateFormat = DateFormat('dd/MM/yyyy');
//   final ValueChanged<DateTime>? onDateSelected;
//   final double? height;
//   final TextEditingController controller;
//   final Color color;
//   final DateTime? initialValue;

//   OrganizameCalendarButton({
//     super.key,
//     this.onDateSelected,
//     this.height,
//     required this.controller,
//     required this.color,
//     this.initialValue,
//   }) {
//     // Inicializa com o formato correto
//     if (initialValue != null) {
//       controller.text = dateFormat.format(initialValue!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(3),
//       onTap: () async {
//         final lastdate = DateTime.now().add(const Duration(days: 10 * 365));

//         final DateTime? selectedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: lastdate,
//         );

//         if (selectedDate != null) {
//           // Atualiza o controlador e o campo de texto com a data selecionada
//           controller.text = dateFormat.format(selectedDate);
//           context.read<TaskController>().setSelectedDate = selectedDate;

//           // Invoca o callback se definido
//           onDateSelected?.call(selectedDate);
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.all(5),
//         height: height ?? 48,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(3),
//           border: Border.all(color: context.primaryColor, width: 1),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 5),
//             Icon(
//               Icons.calendar_today,
//               color: context.secondaryColor,
//             ),
//             const SizedBox(width: 10),
//             Selector<TaskController, DateTime?>(
//               selector: (context, controller) => controller.getSelectedDate,
//               builder: (context, selectedDate, child) {
//                 if (controller.text.isEmpty) {
//                   return Text(
//                     'Data',
//                     style: TextStyle(color: context.primaryColor, fontSize: 16),
//                   );
//                 } else {
//                   return Text(
//                     selectedDate != null
//                         ? dateFormat.format(selectedDate)
//                         : controller.text,
//                     style: TextStyle(color: context.primaryColor, fontSize: 16),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:provider/provider.dart';

class OrganizameCalendarButton extends StatelessWidget {
  final dateFormat = DateFormat('dd/MM/yyyy');
  final ValueChanged<DateTime>? onDateSelected;
  final double? height;
  final TextEditingController controller;
  final Color color;
  final DateTime? initialValue;

  OrganizameCalendarButton({
    super.key,
    this.onDateSelected,
    this.height,
    required this.controller,
    required this.color,
    this.initialValue,
  }) {
    
    if (initialValue != null) {
      
      final formattedDate = dateFormat.format(initialValue!);
      controller.text =
          DateFormat('yyyy-MM-dd').parse(formattedDate).toIso8601String();

      
      onDateSelected?.call(initialValue!);
    }
  }

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

        if (selectedDate != null) {
          controller.text = dateFormat.format(selectedDate);
          context.read<TaskController>().setSelectedDate = selectedDate;
          onDateSelected?.call(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        height: height ?? 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: context.primaryColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: context.secondaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Selector<TaskController, DateTime?>(
                selector: (context, controller) => controller.getSelectedDate,
                builder: (context, selectedDate, child) {
                  String displayText;
                  if (controller.text.isEmpty) {
                    displayText = 'Data';
                  } else {
                    try {
                      // Converte a data ISO para exibição em dd/MM/yyyy
                      final date = DateTime.parse(controller.text);
                      displayText = dateFormat.format(date);
                    } catch (e) {
                      displayText = controller.text;
                    }
                  }

                  return Text(
                    displayText,
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
