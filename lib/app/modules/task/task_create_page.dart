import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textfield.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/core/notifier/defaut_listener_notifier.dart';

import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/core/Widget/organizame_calendar_button.dart';
import 'package:organizame/app/core/Widget/organizame_time.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskController _controller;
  final TaskObject? task;

  const TaskCreatePage({
    super.key,
    required TaskController controller,
    this.task
    }) : _controller = controller;

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _globalKey = GlobalKey<FormState>();
  final descriptionEC = TextEditingController();
  final dateEC = TextEditingController();
  final timeEC = TextEditingController();
  final observationsEC = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Se for uma tarefa existente, preenche os campos com os dados da tarefa
    if (widget.task != null) {
      final task = widget.task!;
      descriptionEC.text = task.descricao;
      dateEC.text = DateFormat('dd/MM/yyyy').format(task.data);
      timeEC.text = DateFormat('HH:mm').format(task.hora);
      observationsEC.text = task.observacao ?? '';
    }

    DefaultListenerNotifier(
      changeNotifier: widget._controller,
    ).listener(
        context: context,
        sucessCallback: (notifier, listenerInstance) {
          listenerInstance.dispose();
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    descriptionEC.dispose();
    dateEC.dispose();
    timeEC.dispose();
    observationsEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        key: _globalKey,
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
                    Text(widget.task == null ? 'NOVA TAREFA' : 'EDITAR TAREFA',
                        style: context.titleDefaut),
                    const SizedBox(height: 20),
                    OrganizameTextformfield(
                      enabled: true,
                      validator: Validatorless.multiple([
                        Validatorless.required('Campo obrigatório'),
                        Validatorless.max(50, 'Nome muito longo'),
                      ]),
                      label: 'Descrição',
                      controller: descriptionEC,
                    ),
                    const SizedBox(height: 10),
                    // Colocando Data e Hora numa única linha
                    Row(
                      children: [
                        Expanded(
                          child: OrganizameCalendarButton(
                            controller: dateEC,
                            color: context.primaryColorLight,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OrganizameTimeButton(
                            controller: timeEC,
                            label: 'Hora',
                            color: context.primaryColorLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Caixa de texto de Observações com altura de 3 linhas
                    SizedBox(
                      height: 120, // Ajusta a altura total
                      child: OrganizameTextField(
                        controller: observationsEC,
                        label: 'Observações',
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OrganizameElevatedButton(
                      label: 'Salvar',
                      onPressed: () {
                        final formValid = _globalKey.currentState?.validate() ?? false;

                        if (formValid) {
                          if (widget.task != null) {
                            // Atualiza a tarefa existente
                            context.read<TaskController>().updateTask(
                                  TaskObject(
                                    id: widget.task!.id,
                                    descricao: descriptionEC.text,
                                    data: DateFormat('dd/MM/yyyy')
                                        .parse(dateEC.text),
                                    hora:
                                        DateFormat('HH:mm').parse(timeEC.text),
                                    observacao: observationsEC.text,
                                    finalizado: widget.task!.finalizado,
                                  ),
                                );
                          } else {
                            // Cria uma nova tarefa
                            context.read<TaskController>().saveTask(
                                  descriptionEC.text,
                                  dateEC.text,
                                  timeEC.text,
                                  observationsEC.text,
                                );
                          }

                          Navigator.pop(
                              context); // Fecha a tela após salvar ou atualizar
                        }
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
