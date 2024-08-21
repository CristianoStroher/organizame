import 'package:flutter/material.dart';
import 'package:organizame/app/modules/task/task_controller.dart';

class TaskPage extends StatelessWidget {
  TaskController _controller;

  TaskPage({super.key, required TaskController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
      ),
      body: Container(),
    );
  }
}
