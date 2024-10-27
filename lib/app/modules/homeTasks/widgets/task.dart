import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/task/task_create_page.dart';
import 'package:provider/provider.dart';

class Task extends StatelessWidget {
  final TaskController controller;
  final TaskObject object;
  final dateFormatData = DateFormat('dd/MM/yyyy');
  final dateFormatHora = DateFormat('HH:mm');

  Task({
    super.key,
    required this.object,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskCreatePage(
              controller: controller,
              task: object,
            ),
          ),
        ).then((value) async {
          await context.read<HomeController>().loadAllTasks();
          await context
              .read<HomeController>()
              .findFilter(filter: TaskFilterEnum.today);
        });
      },
      child: SizedBox(
        child: Column(
          children: [
            Divider(
              color: Colors.grey[300], // Linha cinza acima
              thickness: 1.5,
              height: 0,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(.8),
              leading: Checkbox(
                checkColor: context.primaryColor,
                activeColor: context.primaryColorLight,
                fillColor: WidgetStateProperty.all(context.primaryColorLight),
                side: BorderSide(color: context.primaryColor, width: 1),
                value: object.finalizado,
                onChanged: (value) async {
                  await context.read<HomeController>().finishTask(object);
                  print(object.finalizado);
                },
              ),
              title: Text(
                object.descricao.toUpperCase(),
                style: TextStyle(
                  decoration:
                      object.finalizado ? TextDecoration.lineThrough : null,
                  fontFamily: context.titleDefaut.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.secondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormatData.format(object.data),
                    style: TextStyle(
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: context.secondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormatHora.format(object.hora),
                    style: TextStyle(
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.secondaryColor,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: context.secondaryColor),
                onPressed: () async {
                  final bool? confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Excluir tarefa', style: context.titleMedium),
                      content: Text(
                        'Deseja excluir a tarefa ${object.descricao}?',
                        style: TextStyle(color: context.primaryColor),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancelar', style: context.titleDefaut),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'Excluir',
                            style: TextStyle(
                                color: context.primaryColor, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    Loader.show(context);
                    try {
                      final result = //await controller.deleteTask(object);
                          await context
                              .read<HomeController>()
                              .deleteTask(object);

                      Loader.hide();
                      if (result) {
                        Messages.of(context)
                            .showInfo('Tarefa excluída com sucesso');
                      } else {
                        Messages.of(context)
                            .showError('Erro ao excluir tarefa');
                      }
                    } catch (e) {
                      Loader.hide();
                      Messages.of(context).showError('Erro ao excluir tarefa');
                    }
                  }
                },
              ),
            ),
            Divider(
              color: Colors.grey[300], // Linha cinza abaixo
              thickness: 1.5,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
