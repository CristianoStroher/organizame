import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_object.dart';

class Task extends StatelessWidget {
  final TaskObject object;
  final dateFormatData = DateFormat('dd/MM/yyyy');
  final dateFormatHora = DateFormat('HH:mm');

  Task({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print ('abrir a tarefa e alterar');
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
                fillColor: WidgetStatePropertyAll(context.primaryColorLight),
                side: BorderSide(color: context.primaryColor, width: 1),
                value: object.finalizado,
                onChanged: (value) {},
              ),
              title: Text(
                object.descricao.toUpperCase(),
                style: TextStyle(
                  decoration: object.finalizado ? TextDecoration.lineThrough : null,
                  fontFamily: context.titleDefaut.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    dateFormatData.format(object.data),
                    style: TextStyle(
                      decoration: false ? TextDecoration.lineThrough : null,
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dateFormatHora.format(object.hora),
                    style: TextStyle(
                      decoration: false ? TextDecoration.lineThrough : null,
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.secondaryColor,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: context.secondaryColor),
                onPressed: () {
                  // Ação para excluir a tarefa
                  // Adicione a lógica para excluir a tarefa aqui
                  Messages.of(context).showInfo('Tarefa excluída com sucesso!');
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
