import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/Widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/Widget/organizame_textfield.dart';
import 'package:organizame/app/core/Widget/organizame_textformfield.dart';
import 'package:organizame/app/core/notifier/defaut_listener_notifier.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/task/widgets/organizame_calendar_button.dart';
import 'package:organizame/app/modules/task/widgets/organizame_time.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskController _controller;

  const TaskCreatePage({super.key, required TaskController controller})
      : _controller = controller;

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
    DefautListenerNotifier(
      changeNotifier: widget._controller,
    ).listener(context: context, sucessCallback: (notifier, listenerInstance) {
      listenerInstance.removeListener();
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
                    Text('NOVA TAREFA', style: context.titleDefaut),
                    const SizedBox(height: 20),
                    OrganizameTextformfield(
                      validator: Validatorless.multiple([
                        Validatorless.required('Campo obrigatório'),
                        Validatorless.max(50, 'Nome muito longo'),
                      ]),
                      label: 'Descrição',
                      controller: descriptionEC,
                    ),
                    const SizedBox(height: 20),
                    // Colocando Data e Hora numa única linha
                    Row(
                      children: [
                        Expanded(
                          child: OrganizameCalendarButton(
                            controller: dateEC,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OrganizameTimeButton(
                            controller: timeEC,
                            label: 'Hora',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                          widget._controller.saveTask(
                            descriptionEC.text,
                            dateEC.text,
                            timeEC.text,
                            observationsEC.text,
                          );
                          Navigator.pop(context);
                         
                          
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
