import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
import 'package:provider/provider.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.select<HomeController, bool>(
          (controller) => controller.filterSelected == TaskFilterEnum.week),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'DIA DA SEMANA',
            style: context.titleDefaut,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 95,
            child: Selector<HomeController, DateTime>(
              selector: (context, controller) => controller.initialDateOfWeek ?? DateTime.now(),
              builder: (_, value, __) {
                return DatePicker(
                value,
                locale: 'pt_BR',
                initialSelectedDate: value,
                selectionColor: context.primaryColor,
                selectedTextColor: context.scaffoldBackgroundColor,
                daysCount: 7,
                dayTextStyle: TextStyle(
                    color: context.primaryColor,
                    fontSize: 12),
                monthTextStyle: TextStyle(
                    color: context.primaryColor,
                    fontSize: 12),
                dateTextStyle: TextStyle(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                    onDateChange: (date) {
                      context.read<HomeController>().filterByDate(date);
                    });
              },
              ),
          ),
        ],
      ),
    );
  }
}
