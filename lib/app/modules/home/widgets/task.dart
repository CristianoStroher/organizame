import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(     
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
              value: false,
              onChanged: (value) {},
            ),
            title: Text(
              'Nome da Tarefa',
              style: TextStyle(
                decoration: false ? TextDecoration.lineThrough : null,
                fontFamily: context.titleDefaut.fontFamily,
                fontWeight: FontWeight.bold,
                color: context.primaryColor,
              ),
            ),
            subtitle: Text(
              '18/08/2024 10:00',
              style: TextStyle(
                decoration: false ? TextDecoration.lineThrough : null,
                fontFamily: context.titleDefaut.fontFamily,
                color: context.secondaryColor,
              ),
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
    );
  }
}
