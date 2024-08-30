// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/models/task_total_filter.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:provider/provider.dart';

class HomeCardFilter extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final Color linearProgress;
  final Color valueColor;
  final TaskFilterEnum taskFilterEnum;
  final TaskTotalFilter? taskTotalFilter;
  final bool isSelected;

  const HomeCardFilter({
    super.key,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.linearProgress,
    required this.valueColor,
    required this.taskFilterEnum,
    this.taskTotalFilter,
    required this.isSelected,
  });

  double _getPercentFinished() {
    final total = taskTotalFilter?.totalTasks ?? 0.0;
    final totalFinished = taskTotalFilter?.totalTasksFinished ?? 0.1;

    if (total == 0) {
      return 0.0;
    }

    final percent = (totalFinished * 100) / total;
    return percent / 100;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HomeController>().findFilter(filter: taskFilterEnum),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 100,
          maxWidth: 150,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : context.primaryColor,
            width: 1
            ),
        ),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${taskTotalFilter?.totalTasks ?? 0} TAREFAS',
              style: TextStyle(
                color: isSelected ? context.scaffoldBackgroundColor : textColor,
                fontSize: 10
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  color: isSelected ? context.scaffoldBackgroundColor : textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: _getPercentFinished(),
              ),
              duration: const Duration(seconds: 1),
              builder: (context, double value, child) => LinearProgressIndicator(
                value: value,
                backgroundColor: isSelected ? context.scaffoldBackgroundColor : linearProgress,
                valueColor: AlwaysStoppedAnimation(isSelected ? context.primaryColorLight : valueColor,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
