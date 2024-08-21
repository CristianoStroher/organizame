import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/Widget/organizame_textfield.dart';
import 'package:organizame/app/core/Widget/organizame_textformfield.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';

class TaskPage extends StatelessWidget {
  final TaskController _controller;

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
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: context.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Form(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('NOVA TAREFA', style: context.titleDefaut),
                    const SizedBox(height: 20),
                    OrganizameTextformfield(label: 'Descrição'),
                    const SizedBox(height: 20),
                    
                    // Colocando Data e Hora numa única linha
                    Row(
                      children: [
                        Expanded(
                          child: OrganizameTextformfield(label: 'Data'),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OrganizameTextformfield(
                            label: 'Hora',
                            hintText: '00:00',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Caixa de texto de Observações com altura de 3 linhas
                    const SizedBox(
                      height: 120, // Ajusta a altura total
                      child: OrganizameTextField(label: 'Observações', maxLines: 4),
                    ),
                    const SizedBox(height: 20),
                    OrganizameElevatedButton(
                      label: 'Salvar',
                      onPressed: () {
                        // Implementar ação do botão
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
