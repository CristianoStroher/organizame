// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/Widget/organizame_navigatorbar.dart';
import 'package:organizame/app/core/notifier/defaut_listener_notifier.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/modules/home/widgets/home_drawer.dart';
import 'package:organizame/app/modules/home/widgets/home_filters.dart';
import 'package:organizame/app/modules/home/widgets/home_header.dart';
import 'package:organizame/app/modules/home/widgets/home_task.dart';
import 'package:organizame/app/modules/home/widgets/home_week_filter.dart';
import 'package:organizame/app/modules/task/task_module.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;

  const HomePage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

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

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await context.read<HomeController>().loadAllTasks();
      await context
          .read<HomeController>()
          .findFilter(filter: TaskFilterEnum.today);
     
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
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
            onSelected: (bool value) => context
                .read<HomeController>()
                .showOrHideFinishingTasks(),
            

            itemBuilder: (context) {
              return [
                PopupMenuItem<bool>(
                  value: true,
                  child: Text(
                    '${context.read<HomeController>().showFinishingTasks ? 'Esconder' : 'Mostrar'} tarefas finalizadas',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
                PopupMenuItem<bool>(
                  child: Text(
                    'Tarefas antigas',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ];
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
      bottomNavigationBar: const OrganizameNavigatorbar(),
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
