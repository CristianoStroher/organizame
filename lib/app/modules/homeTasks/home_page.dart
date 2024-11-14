// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/messages.dart';

import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_navigatorbar.dart';
import 'package:organizame/app/core/notifier/defaut_listener_notifier.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_drawer.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_filters.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_header.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_task.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_week_filter.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/task/task_module.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  final TaskController _taskController;

  const HomePage({
    super.key,
    required HomeController homeController,
    required TaskController taskController,
  })  : _homeController = homeController,
        _taskController = taskController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      sucessCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
      },
    );

    DefaultListenerNotifier(changeNotifier: widget._taskController).listener(
        context: context,
        sucessCallback: (notifier, listenerInstance) {
          listenerInstance.dispose();
        });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await context.read<HomeController>().loadAllTasks();
      await context
          .read<HomeController>()
          .findFilter(filter: TaskFilterEnum.today);
    });
  }

  void _showOldTasksFilter(BuildContext context) {
    final controller = context.read<HomeController>();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Buscar Tarefas Antigas', style: context.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Data inicial
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'De',
                  style: TextStyle(color: context.primaryColor),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        startDate != null
                            ? DateFormat('dd/MM/yyyy').format(startDate!)
                            : 'Selecione a data inicial',
                        style: TextStyle(color: context.secondaryColor),
                      ),
                    ),
                    if (startDate != null)
                      IconButton(
                        icon: Icon(Icons.clear, color: context.secondaryColor),
                        onPressed: () => setState(() => startDate = null),
                      ),
                  ],
                ),
                trailing:
                    Icon(Icons.calendar_today, color: context.secondaryColor),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => startDate = picked);
                  }
                },
              ),

              // Data final
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Até',
                  style: TextStyle(color: context.primaryColor),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        endDate != null
                            ? DateFormat('dd/MM/yyyy').format(endDate!)
                            : 'Selecione a data final',
                        style: TextStyle(color: context.secondaryColor),
                      ),
                    ),
                    if (endDate != null)
                      IconButton(
                        icon: Icon(Icons.clear, color: context.secondaryColor),
                        onPressed: () => setState(() => endDate = null),
                      ),
                  ],
                ),
                trailing:
                    Icon(Icons.calendar_today, color: context.secondaryColor),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => endDate = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: context.primaryColorLight,
                side: BorderSide(color: context.primaryColor, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Cancelar', style: context.titleDefaut),
            ),
            TextButton(
              onPressed: () {
                if (startDate == null && endDate == null) {
                  Messages.of(context)
                      .showError('Selecione pelo menos uma data');
                  return;
                }

                if (startDate != null &&
                    endDate != null &&
                    endDate!.isBefore(startDate!)) {
                  Messages.of(context).showError(
                      'Data final deve ser posterior à data inicial');
                  return;
                }

                controller.findOldTasks(startDate: startDate, endDate: endDate);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: context.primaryColor,
                side: BorderSide(color: context.primaryColor, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Buscar',
                style:
                    TextStyle(color: context.primaryColorLight, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _goToTaskPage(BuildContext appContext) async {
    await Navigator.of(appContext).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInQuad,
          );
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return TaskModule(context).getPage('/task/create', context);
        },
      ),
    );
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        colorDrawer: context.primaryColorLight,
        backgroundButton: context.primaryColorLight,
      ),
      appBar: AppBar(
        backgroundColor: context.primaryColorLight,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrganizameLogoMovie(
              text: 'OrganizaMe',
              part1Color: context.primaryColor,
              part2Color: context.scaffoldBackgroundColor,
            ),
            const SizedBox(width: 5),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(OrganizameIcons.filter,
                size: 20, color: context.primaryColor),
            itemBuilder: (context) {
              return [
                PopupMenuItem<bool>(
                  value: true,
                  child: Text(
                    '${context.read<HomeController>().showFinishingTasks ? 'Esconder' : 'Mostrar'} tarefas finalizadas',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'old',
                  child: Text(
                    'Tarefas antigas',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == true) {
                context.read<HomeController>().showOrHideFinishingTasks();
              } else if (value == 'old') {
                _showOldTasksFilter(context);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _goToTaskPage(context);
          context.read<HomeController>().refreshPage();
        },
        backgroundColor: context.primaryColor,
        child: Icon(Icons.add, color: context.primaryColorLight),
      ),
      bottomNavigationBar: OrganizameNavigatorbar(
        color: context.primaryColorLight,
        initialIndex: index,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * 0.9,
                minHeight: constraints.maxHeight * 0.9,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTask(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
