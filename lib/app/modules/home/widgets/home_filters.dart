import 'package:flutter/material.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_total_filter.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/modules/home/widgets/home_card_filter.dart';
import 'package:provider/provider.dart';


class HomeFilters extends StatelessWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTROS',
          style: context.titleDefaut,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              HomeCardFilter(
                isSelected: context.select<HomeController, TaskFilterEnum>((value) => value.filterSelected) == TaskFilterEnum.today,
                taskFilterEnum: TaskFilterEnum.today,
                taskTotalFilter: TaskTotalFilter(totalTasks: 20, totalTasksFinished: 5),
                label: 'HOJE',
                color: context.primaryColor,
                borderColor: context.primaryColor,
                textColor: context.primaryColor,
                linearProgress: context.scaffoldBackgroundColor,
                valueColor: context.secondaryColor,
              ),
              HomeCardFilter(
                isSelected: context.select<HomeController, TaskFilterEnum>((value) => value.filterSelected) == TaskFilterEnum.tomorrow,
                taskFilterEnum: TaskFilterEnum.tomorrow,
                taskTotalFilter: TaskTotalFilter(totalTasks: 10, totalTasksFinished: 5),
                label: 'AMANHÃ',
                color: const Color(0xFFFAFFC5),
                borderColor:context.primaryColor,
                textColor:context.primaryColor,
                valueColor:const Color.fromARGB(255, 185, 193, 52),
                linearProgress: Colors.white,
              ),
              HomeCardFilter(
                isSelected: context.select<HomeController, TaskFilterEnum>((value) => value.filterSelected) == TaskFilterEnum.week,
                taskFilterEnum: TaskFilterEnum.week,
                taskTotalFilter: TaskTotalFilter(totalTasks: 10, totalTasksFinished: 5),
                label: 'SEMANA',
                color: const Color(0xFFDDFFCC),
                borderColor: context.primaryColor,
                textColor: context.primaryColor,
                valueColor: const Color.fromARGB(255, 93, 130, 75),
                linearProgress: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
