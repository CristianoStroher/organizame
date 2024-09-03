import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/modules/home/widgets/task.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:provider/provider.dart';

class HomeTask extends StatefulWidget {
  const HomeTask({super.key});

  @override
  State<HomeTask> createState() => _HomeTaskState();
}

class _HomeTaskState extends State<HomeTask> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Selector<HomeController, String>(
          selector: (context, controller) =>
              controller.filterSelected.description,
          builder: (context, value, child) {
            return Text(
              'TAREFAS $value',
              style: context.titleDefaut,
            );
          },
        ),
        const SizedBox(height: 10),
        Column(
          children: context
              .select<HomeController, List<TaskObject>>(
                  (controller) => controller.filteredTasks)
              .map((t) =>
                  Task(object: t, controller: context.read<TaskController>()))
              .toList(),
        )
      ],
    ));
  }
}
