import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';

class TaskPage extends StatelessWidget {
  TaskController _controller;

  TaskPage({super.key, required TaskController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: context.primaryColorLight,
          automaticallyImplyLeading: false,
          title: OrganizameLogoMovie(
            text: 'Tarefas',
            part1Color: context.primaryColor,
            part2Color: context.primaryColor,
          ),
          leading:const SizedBox.shrink(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: context.primaryColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]),
      body: Container(),
    );
  }
}
